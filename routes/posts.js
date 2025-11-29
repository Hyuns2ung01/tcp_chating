const express = require('express');
const router = express.Router();
const pool = require('../db');

// [로그인 체크 미들웨어] 
// 이 함수를 라우터에 끼워넣으면 로그인을 검사합니다.
const checkLogin = (req, res, next) => {
    if (!req.session.user) {
        return res.send(`<script>alert('로그인이 필요한 서비스입니다.'); location.href='/login';</script>`);
    }
    next();
};

// 목록 + 검색 + 페이징
router.get('/', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = 10;
        const offset = (page - 1) * limit;
        const search = req.query.search || "";

            // ORDER BY 부분을 '제목([공지])' 검사에서 -> '카테고리(공지)' 검사로 변경
const sql = `
    SELECT p.*, u.name AS author_name 
    FROM posts p 
    LEFT JOIN users u ON p.author_id = u.id
    WHERE p.title LIKE ? 
    ORDER BY 
        CASE WHEN p.category = '공지' THEN 0 ELSE 1 END ASC,
        p.id DESC
    LIMIT ? OFFSET ?
`;

        const [rows] = await pool.query(sql, [`%${search}%`, limit, offset]);

        const [[{ total }]] = await pool.query(
            `SELECT COUNT(*) AS total FROM posts WHERE title LIKE ?`,
            [`%${search}%`]
        );

        res.render("index", {
            posts: rows,
            total,
            totalPages: Math.ceil(total / limit),
            currentPage: page,
            search,
        });
    } catch (error) {
        console.log(error);
        res.status(500).send("목록 로드 오류");
    }
});

// 글쓰기 폼 (checkLogin 추가 -> 로그인 안하면 못 들어옴)
router.get('/new', checkLogin, (req, res) => {
    res.render("new");
});

// 글 저장 (작성자 ID 저장 추가) + 카테고리 추가(11.28)
router.post('/:id/edit', checkLogin, async (req, res) => {
    try {
        const id = req.params.id;
        // 1. 여기서도 category를 받아옵니다.
        const { title, content, category } = req.body;
        const isAdmin = req.session.user.is_admin === 1;

        // 2. [변경됨] 수정할 때도 공지사항 권한 체크
        if (category === '공지' && !isAdmin) {
            return res.send(`<script>alert('🛑 관리자만 공지사항을 선택할 수 있습니다.'); history.back();</script>`);
        }

        // 3. DB 업데이트할 때 category도 같이 수정
        await pool.query(
            `UPDATE posts SET title=?, content=?, category=? WHERE id=?`,
            [title, content, category, id]
        );

        res.redirect(`/posts/${id}`);

    } catch (error) {
        console.error(error);
        res.status(500).send("수정 오류");
    }
});

// 상세 보기
router.get('/:id', async (req, res) => {
    try {
        const id = req.params.id;

        // 조회수 증가
        await pool.query(`UPDATE posts SET view_count = view_count + 1 WHERE id=?`, [id]);

        // posts 테이블과 users 테이블을 합쳐서 작성자 이름(author_name)을 가져옴
        const [[post]] = await pool.query(
            `SELECT p.*, u.name AS author_name 
             FROM posts p 
             LEFT JOIN users u ON p.author_id = u.id 
             WHERE p.id=?`,
            [id]
        );

        if (!post) return res.status(404).send("게시글을 찾을 수 없습니다.");

        res.render("show", { post });

    } catch (error) {
        res.status(500).send("상세 보기 오류");
    }
});

// 삭제 (본인 확인 추가)
router.post('/:id/delete', checkLogin, async (req, res) => {
    try {
        const id = req.params.id;
        const userId = req.session.user.id;
        const isAdmin = req.session.user.is_admin === 1;

        // 먼저 게시글 정보를 가져와서 작성자가 누군지 확인
        const [[post]] = await pool.query(`SELECT * FROM posts WHERE id=?`, [id]);

        if (!post) return res.status(404).send("게시글이 없습니다.");

        // 권한 체크 (작성자이거나 관리자만 통과)
        if (post.author_id !== userId && !isAdmin) {
            return res.send(`<script>alert('작성자만 삭제할 수 있습니다.'); history.back();</script>`);
        }

        // 삭제 실행
        await pool.query(`DELETE FROM posts WHERE id=?`, [id]);
        res.redirect('/posts');

    } catch (error) {
        res.status(500).send("삭제 오류");
    }
});

// 수정 폼 (본인 확인 로직 필요 - 삭제와 비슷하게 구현 권장)
router.get('/:id/edit', checkLogin, async (req, res) => {
    try {
        const id = req.params.id;
        const [[post]] = await pool.query(`SELECT * FROM posts WHERE id=?`, [id]);
        
        if (post.author_id !== req.session.user.id && req.session.user.is_admin !== 1) {
             return res.send(`<script>alert('작성자만 수정할 수 있습니다.'); history.back();</script>`);
        }

        res.render("edit", { post });
    } catch (error) {
        res.status(500).send("오류");
    }
});

// 수정 저장
router.post('/:id/edit', checkLogin, async (req, res) => {
    // 여기도 삭제처럼 본인 확인 로직을 넣는 것이 안전하지만 생략함
    const id = req.params.id;
    const { title, content } = req.body;
    await pool.query(`UPDATE posts SET title=?, content=? WHERE id=?`, [title, content, id]);
    res.redirect(`/posts/${id}`);
});

module.exports = router;