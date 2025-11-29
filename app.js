const express = require('express');
const app = express();
const path = require('path');
const session = require('express-session');

// 필수 모듈 불러오기
const http = require('http');
const { Server } = require("socket.io");

// DB연결
const pool = require('./db');

// 서버 만들기
const server = http.createServer(app);
const io = new Server(server);

// 라우터 불러오기
const postsRouter = require('./routes/posts');
const authRouter = require('./routes/auth');

// EJS 템플릿 엔진 설정
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// POST 요청 및 정적 파일 설정
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// 세션 설정
app.use(session({
    secret: 'secret_key_1234',
    resave: false,
    saveUninitialized: false
}));

// 로그인 사용자 정보
app.use((req, res, next) => {
    res.locals.user = req.session.user || null;
    next();
});

// 라우터 등록
app.use('/', authRouter);
app.use('/posts', postsRouter);
app.use('/chat', require('./routes/chat'));

// 메인 URL > 게시판으로 리다이렉트
app.get('/', (req, res) => {
    res.redirect('/posts');
});

// [Socket.io] 실시간 채팅 로직
io.on('connection', (socket) => {
    console.log('유저 접속됨');

    // 1. 방 입장 (옆에 이름도 띄움)
    socket.on('join room', (data) => {
        // data = { roomId, name }
        socket.join(data.roomId);
        console.log(`${data.name}님이 ${data.roomId}번 방에 입장함`);

        // [시스템 메시지] 입장 알림 전송
        io.to(data.roomId).emit('system message', {
            text: `👋 ${data.name}님이 입장하셨습니다.`
        });
    });

    // 2. 방 나가기
    socket.on('leave room', (data) => {
        // data = { roomId, name }
        socket.leave(data.roomId); // 소켓을 방에서 뺌
        console.log(`${data.name}님이 ${data.roomId}번 방을 나감`);

        // [시스템 메시지] 퇴장 알림
        io.to(data.roomId).emit('system message', {
            text: `🚪 ${data.name}님이 퇴장하셨습니다.`
        });
    });

    // 3. 메시지 전송
    socket.on('chat message', async (data) => {
        try {
            await pool.query(
                'INSERT INTO chat_messages (room_id, user_id, content) VALUES (?, ?, ?)',
                [data.roomId, data.userId, data.text]
            );

            io.to(data.roomId).emit('chat message', {
                name: data.name,
                text: data.text,
                user_id: data.userId
            });
        } catch (err) {
            console.error(err);
        }
    });

    socket.on('disconnect', () => {
        console.log('유저 연결 끊김');
    });
});

//서버실행
server.listen(3000, () => {
    console.log('Server running on http://localhost:3000');
});