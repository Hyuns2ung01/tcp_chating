const express = require('express');
const router = express.Router();
const pool = require('../db');

// 로그인 체크 미들웨어
const checkLogin = (req, res, next) => {
    if (!req.session.user) {
        return res.send(`<script>alert('로그인이 필요한 서비스입니다.'); location.href='/login';</script>`);
    }
    next();
};

// 1. 내 채팅방 목록 보여주기 (JSON 데이터가 아님, 화면 렌더링용)
router.get('/', checkLogin, async (req, res) => {
    try {
        const userId = req.session.user.id;

        const sql = `
            SELECT 
                r.id, 
                r.title, 
                -- (1) 해당 방의 가장 최신 메시지 내용 가져오기
                (SELECT content FROM chat_messages 
                 WHERE room_id = r.id 
                 ORDER BY created_at DESC LIMIT 1) AS last_message,
                
                -- (2) 해당 방의 가장 최신 메시지 시간 가져오기
                (SELECT created_at FROM chat_messages 
                 WHERE room_id = r.id 
                 ORDER BY created_at DESC LIMIT 1) AS last_time,
                
                -- (3) 안 읽은 메시지 개수 구하기
                (SELECT COUNT(*) FROM chat_messages cm 
                 WHERE cm.room_id = r.id 
                 AND cm.created_at > rm.last_read_at) AS unread_count

            FROM chat_rooms r
            JOIN room_members rm ON r.id = rm.room_id
            WHERE rm.user_id = ?
            ORDER BY last_time DESC, r.id DESC
        `;

        const [rooms] = await pool.query(sql, [userId]);

        res.render('chat_list', { rooms });
    } catch (err) {
        console.error(err);
        res.status(500).send("채팅방 목록 오류");
    }
});

// 2. [API] 채팅방 데이터만 가져오기 (화면 이동 없이 로딩)
router.get('/api/:id', checkLogin, async (req, res) => {
    try {
        const roomId = req.params.id;

        // (1) 방 정보
        const [[room]] = await pool.query('SELECT * FROM chat_rooms WHERE id = ?', [roomId]);

        // (2) 메시지 내역
        const [messages] = await pool.query(`
            SELECT m.*, u.name 
            FROM chat_messages m
            JOIN users u ON m.user_id = u.id
            WHERE m.room_id = ?
            ORDER BY m.created_at ASC
        `, [roomId]);

        res.json({ room, messages });
    } catch (err) {
        res.status(500).json({ error: "데이터 로드 오류" });
    }
});

// 3. [API] 메시지 읽음 처리
router.post('/api/read/:roomId', checkLogin, async (req, res) => {
    try {
        const userId = req.session.user.id;
        const roomId = req.params.roomId;

        // 내 마지막 읽은 시간을 현재로 업데이트
        // (주의: DB에 last_read_at 컬럼이 있어야 에러가 안 납니다. 없다면 이 줄을 지우세요)
        await pool.query(
            'UPDATE room_members SET last_read_at = NOW() WHERE room_id = ? AND user_id = ?',
            [roomId, userId]
        );
        res.json({ success: true });
    } catch (err) {
        // 컬럼이 없어서 에러날 수 있으므로 콘솔만 찍고 넘어감
        console.error("읽음 처리 실패 (DB 컬럼 확인 필요):", err.message);
        res.json({ success: false });
    }
});

// 4. 채팅방 생성하기 (직접 만들기)
router.post('/create', checkLogin, async (req, res) => {
    try {
        const { title } = req.body;
        const owner_id = req.session.user.id;

        const [result] = await pool.query('INSERT INTO chat_rooms (title, owner_id) VALUES (?, ?)', [title, owner_id]);
        const newRoomId = result.insertId;

        await pool.query('INSERT INTO room_members (room_id, user_id) VALUES (?, ?)', [newRoomId, owner_id]);

        // 실시간 알림 전송
        const io = req.app.get('io');
        if (io) io.emit('new_room', { id: newRoomId, title: title });

        res.json({ success: true, roomId: newRoomId });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "방 생성 오류" });
    }
});

// 5. 유저 초대하기
router.post('/:id/invite', checkLogin, async (req, res) => {
    try {
        const roomId = req.params.id;
        const { targetUsername } = req.body;

        const [[targetUser]] = await pool.query('SELECT id FROM users WHERE username = ?', [targetUsername]);
        if (!targetUser) return res.send(`<script>alert('존재하지 않는 아이디입니다.'); history.back();</script>`);

        const [[exists]] = await pool.query('SELECT * FROM room_members WHERE room_id=? AND user_id=?', [roomId, targetUser.id]);
        if (exists) return res.send(`<script>alert('이미 참여 중인 유저입니다.'); history.back();</script>`);

        await pool.query('INSERT INTO room_members (room_id, user_id) VALUES (?, ?)', [roomId, targetUser.id]);

        res.redirect('/chat');
    } catch (err) {
        console.error(err);
        res.status(500).send("초대 오류");
    }
});

// 6. 채팅방 시작 (공구 참여 / 1:1 채팅 분류)
router.post('/start', checkLogin, async (req, res) => {
    try {
        const myId = req.session.user.id;
        const { seller_id: sellerId, post_title: postTitle, post_id, category } = req.body;

        let targetRoomId = null;

        // CASE 1: '공구' 카테고리 (단체방)
        if (category === '공구') {
            // 연결된 방이 있는지 확인
            const [[existingRoom]] = await pool.query('SELECT * FROM chat_rooms WHERE linked_post_id = ?', [post_id]);

            if (existingRoom) {
                targetRoomId = existingRoom.id;
            } else {
                const roomTitle = `[공구] ${postTitle}`;
                const [result] = await pool.query(
                    'INSERT INTO chat_rooms (title, owner_id, linked_post_id) VALUES (?, ?, ?)',
                    [roomTitle, sellerId, post_id]
                );
                targetRoomId = result.insertId;
                // 방장 추가
                await pool.query('INSERT INTO room_members (room_id, user_id) VALUES (?, ?)', [targetRoomId, sellerId]);
            }

            // 나 추가 (중복 체크)
            const [[isMember]] = await pool.query('SELECT * FROM room_members WHERE room_id=? AND user_id=?', [targetRoomId, myId]);
            if (!isMember) {
                await pool.query('INSERT INTO room_members (room_id, user_id) VALUES (?, ?)', [targetRoomId, myId]);
            }
        }

        // CASE 2: 중고 (1:1 채팅)
        else {
            const roomTitle = `[중고거래] ${postTitle}`;
            const [result] = await pool.query(
                'INSERT INTO chat_rooms (title, owner_id) VALUES (?, ?)',
                [roomTitle, myId]
            );
            targetRoomId = result.insertId;

            await pool.query('INSERT INTO room_members (room_id, user_id) VALUES (?, ?)', [targetRoomId, myId]);
            await pool.query('INSERT INTO room_members (room_id, user_id) VALUES (?, ?)', [targetRoomId, sellerId]);
        }

        // 목록 화면으로 이동
        res.redirect(`/chat`);

    } catch (err) {
        console.error(err);
        res.status(500).send("채팅방 연결 오류 (DB 컬럼 linked_post_id 확인 필요)");
    }
});

// 7. 채팅방 나가기 (DB 삭제)
router.post('/api/leave', checkLogin, async (req, res) => {
    try {
        const { roomId } = req.body;
        const userId = req.session.user.id;

        // 1. 멤버 테이블에서 삭제 (방 나가기)
        await pool.query('DELETE FROM room_members WHERE room_id = ? AND user_id = ?', [roomId, userId]);

        // 2. 방에 남은 사람이 있는지 확인
        const [[{ count }]] = await pool.query('SELECT COUNT(*) as count FROM room_members WHERE room_id = ?', [roomId]);

        // 3. 아무도 없으면 방 자체를 삭제 (청소)
        if (count === 0) {
            await pool.query('DELETE FROM chat_rooms WHERE id = ?', [roomId]);
        }

        res.json({ success: true });

    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: "방 나가기 오류" });
    }
});

// 8. 채팅방 멤버 목록 가져오기 API
router.get('/api/:roomId/members', checkLogin, async (req, res) => {
    try {
        const roomId = req.params.roomId;

        // room_members 테이블과 users 테이블을 조인해서 이름 가져오기
        const [members] = await pool.query(`
            SELECT u.name, u.username, u.id
            FROM room_members rm
            JOIN users u ON rm.user_id = u.id
            WHERE rm.room_id = ?
            ORDER BY u.name ASC
        `, [roomId]);

        res.json({ success: true, members });

    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: "멤버 로드 실패" });
    }
});

// 9. 유저 검색 API (이름 또는 아이디로 검색)
router.get('/api/users/search', checkLogin, async (req, res) => {
    try {
        const keyword = req.query.keyword;
        const myId = req.session.user.id;

        if (!keyword) return res.json({ users: [] });

        // 나(myId)는 제외하고 검색
        // 이름(name) 또는 아이디(username)에 키워드가 포함된 사람 찾기
        const [users] = await pool.query(`
            SELECT id, username, name 
            FROM users 
            WHERE (name LIKE ? OR username LIKE ?) 
            AND id != ?
            LIMIT 10
        `, [`%${keyword}%`, `%${keyword}%`, myId]);

        res.json({ users });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "검색 오류" });
    }
});

module.exports = router;