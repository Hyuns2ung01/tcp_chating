const express = require('express');
const router = express.Router();
const pool = require('../db');

// 로그인 체크 미들웨어
const checkLogin = (req, res, next) => {
    if (!req.session.user) {
        return res.send(`<script>alert('로그인이 필요합니다.'); location.href='/login';</script>`);
    }
    next();
};

// 1. 내 채팅방 목록 보여주기
router.get('/', checkLogin, async (req, res) => {
    try {
        const userId = req.session.user.id;

        const sql = `
            SELECT r.* FROM chat_rooms r
            JOIN room_members m ON r.id = m.room_id
            WHERE m.user_id = ?
            ORDER BY r.id DESC
        `;

        const [rooms] = await pool.query(sql, [userId]);

        res.render('chat_list', { rooms });
    } catch (err) {
        console.error(err);
        res.status(500).send("채팅방 목록 오류");
    }
});

// 2. [수정됨] 채팅방 생성하기 (생성 후 멤버로 자동 추가)
router.post('/create', checkLogin, async (req, res) => {
    try {
        const { title } = req.body;
        const owner_id = req.session.user.id;

        // (1) 방 만들기
        const [result] = await pool.query('INSERT INTO chat_rooms (title, owner_id) VALUES (?, ?)', [title, owner_id]);
        const newRoomId = result.insertId; // 새로 만들어진 방 번호

        // (2) 나를 멤버로 추가하기
        await pool.query('INSERT INTO room_members (room_id, user_id) VALUES (?, ?)', [newRoomId, owner_id]);

        res.redirect('/chat');
    } catch (err) {
        console.error(err);
        res.status(500).send("방 생성 오류");
    }
});

// 3. 채팅방 입장하기
router.get('/:id', checkLogin, async (req, res) => {
    try {
        const roomId = req.params.id;
        const userId = req.session.user.id;

        // [보안] 내가 이 방 멤버인지 확인
        const [[member]] = await pool.query('SELECT * FROM room_members WHERE room_id=? AND user_id=?', [roomId, userId]);
        if (!member) {
            return res.send(`<script>alert('참여 권한이 없는 방입니다. 초대를 받아주세요.'); location.href='/chat';</script>`);
        }

        // 방 정보
        const [[room]] = await pool.query('SELECT * FROM chat_rooms WHERE id = ?', [roomId]);

        // 메시지 내역
        const [messages] = await pool.query(`
            SELECT m.*, u.name 
            FROM chat_messages m
            JOIN users u ON m.user_id = u.id
            WHERE m.room_id = ?
            ORDER BY m.created_at ASC
        `, [roomId]);

        res.render('chat_room', { room, messages });
    } catch (err) {
        res.status(500).send("오류 발생");
    }
});

// 4. 유저 초대하기
router.post('/:id/invite', checkLogin, async (req, res) => {
    try {
        const roomId = req.params.id;
        const { targetUsername } = req.body; // 초대할 사람 아이디

        // 1. 초대할 유저가 존재하는지 찾기
        const [[targetUser]] = await pool.query('SELECT id FROM users WHERE username = ?', [targetUsername]);
        if (!targetUser) {
            return res.send(`<script>alert('존재하지 않는 아이디입니다.'); history.back();</script>`);
        }

        // 2. 이미 멤버인지 확인
        const [[exists]] = await pool.query('SELECT * FROM room_members WHERE room_id=? AND user_id=?', [roomId, targetUser.id]);
        if (exists) {
            return res.send(`<script>alert('이미 참여 중인 유저입니다.'); history.back();</script>`);
        }

        // 3. 멤버 추가
        await pool.query('INSERT INTO room_members (room_id, user_id) VALUES (?, ?)', [roomId, targetUser.id]);

        res.send(`<script>alert('${targetUsername}님을 초대했습니다!'); location.href='/chat/${roomId}';</script>`);

    } catch (err) {
        console.error(err);
        res.status(500).send("초대 오류");
    }
});

module.exports = router;