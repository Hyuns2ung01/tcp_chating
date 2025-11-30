const express = require('express');
const router = express.Router();
const pool = require('../db');

// 로그인 체크
const checkLogin = (req, res, next) => {
    if (!req.session.user) {
        return res.send(`<script>alert('로그인이 필요한 서비스입니다.'); location.href='/login';</script>`);
    }
    next();
};

// 1. 목록 + 검색 + 페이징 + 카테고리 필터
router.get('/', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = 10;
        const offset = (page - 1) * limit;

        const search = req.query.search || "";
        const category = req.query.category || "all";

        let whereClause = "WHERE p.title LIKE ?";
        let queryParams = [`%${search}%`];

        if (category !== "all") {
            if (category === "공지") {
                whereClause += " AND p.category = ?";
                queryParams.push(category);
            } else {
                whereClause += " AND (p.category = ? OR p.category = '공지')";
                queryParams.push(category);
            }
        }

        let countSql = `SELECT COUNT(*) AS total FROM posts p ${whereClause}`;
        const [[{ total }]] = await pool.query(countSql, queryParams);

        queryParams.push(limit, offset);

        const sql = `
            SELECT p.*, u.name AS author_name 
            FROM posts p 
            LEFT JOIN users u ON p.author_id = u.id
            ${whereClause}
            ORDER BY 
                CASE WHEN p.category = '공지' THEN 0 ELSE 1 END ASC,
                p.id DESC
            LIMIT ? OFFSET ?
        `;

        const [rows] = await pool.query(sql, queryParams);

        res.render("index", {
            posts: rows,
            total,
            totalPages: Math.ceil(total / limit),
            currentPage: page,
            search,
            category,
        });

    } catch (error) {
        console.log(error);
        res.status(500).send("목록 로드 오류");
    }
});

// 2. 글쓰기 폼
router.get('/new', checkLogin, (req, res) => {
    res.render("new");
});

// 3. 글 저장 (INSERT)
router.post('/', checkLogin, async (req, res) => {
    try {
        const { title, content, category } = req.body;
        const author_id = req.session.user.id;
        const isAdmin = req.session.user.is_admin === 1;

        // 공지사항 권한 체크
        if (category === '공지' && !isAdmin) {
            return res.send(`<script>alert('🛑 관리자만 공지사항을 작성할 수 있습니다.'); history.back();</script>`);
        }

        // DB 저장 (INSERT)
        await pool.query(
            `INSERT INTO posts (title, content, author_id, category) VALUES (?, ?, ?, ?)`,
            [title, content, author_id, category]
        );

        res.redirect('/posts');

    } catch (error) {
        console.error(error);
        res.status(500).send("글 작성 오류");
    }
});

// 4. 상세 보기
router.get('/:id', async (req, res) => {
    try {
        const id = req.params.id;

        await pool.query(`UPDATE posts SET view_count = view_count + 1 WHERE id=?`, [id]);

        // (1) 게시글 가져오기
        const [[post]] = await pool.query(
            `SELECT p.*, u.name AS author_name 
             FROM posts p 
             LEFT JOIN users u ON p.author_id = u.id 
             WHERE p.id=?`,
            [id]
        );

        if (!post) return res.status(404).send("게시글을 찾을 수 없습니다.");

        // (2) 댓글 목록 가져오기 (작성자 이름 포함)
        const [comments] = await pool.query(
            `SELECT c.*, u.name AS commenter_name 
             FROM comments c
             JOIN users u ON c.user_id = u.id
             WHERE c.post_id = ?
             ORDER BY c.created_at DESC`, // 최신 댓글이 위로
            [id]
        );

        // post와 comments를 둘 다 보냄
        res.render("show", { post, comments });

    } catch (error) {
        res.status(500).send("상세 보기 오류");
    }
});

// 5. 수정 폼 (권한 체크 포함)
router.get('/:id/edit', checkLogin, async (req, res) => {
    try {
        const id = req.params.id;
        const [[post]] = await pool.query(`SELECT * FROM posts WHERE id=?`, [id]);

        // 작성자 본인 확인 (관리자는 통과)
        if (post.author_id !== req.session.user.id && req.session.user.is_admin !== 1) {
            return res.send(`<script>alert('작성자만 수정할 수 있습니다.'); history.back();</script>`);
        }

        res.render("edit", { post });
    } catch (error) {
        res.status(500).send("수정 페이지 오류");
    }
});

// 6. 수정 저장 (UPDATE)
router.post('/:id/edit', checkLogin, async (req, res) => {
    try {
        const id = req.params.id;
        const { title, content, category } = req.body;
        const isAdmin = req.session.user.is_admin === 1;

        // 수정 시에도 공지사항 권한 체크
        if (category === '공지' && !isAdmin) {
            return res.send(`<script>alert('🛑 관리자만 공지사항을 선택할 수 있습니다.'); history.back();</script>`);
        }

        // DB 업데이트
        await pool.query(
            `UPDATE posts SET title=?, content=?, category=? WHERE id=?`,
            [title, content, category, id]
        );

        res.redirect(`/posts/${id}`);

    } catch (error) {
        console.error(error);
        res.status(500).send("수정 저장 오류");
    }
});

// 7. 삭제
router.post('/:id/delete', checkLogin, async (req, res) => {
    try {
        const id = req.params.id;
        const userId = req.session.user.id;
        const isAdmin = req.session.user.is_admin === 1;

        const [[post]] = await pool.query(`SELECT * FROM posts WHERE id=?`, [id]);

        if (!post) return res.status(404).send("게시글이 없습니다.");

        if (post.author_id !== userId && !isAdmin) {
            return res.send(`<script>alert('작성자만 삭제할 수 있습니다.'); history.back();</script>`);
        }

        await pool.query(`DELETE FROM posts WHERE id=?`, [id]);
        res.redirect('/posts');

    } catch (error) {
        res.status(500).send("삭제 오류");
    }
});

// 8. 댓글 작성
router.post('/:id/comments', checkLogin, async (req, res) => {
    try {
        const postId = req.params.id;
        const { content } = req.body;
        const userId = req.session.user.id;

        await pool.query(
            `INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)`,
            [postId, userId, content]
        );

        res.redirect(`/posts/${postId}`); // 다시 해당 글로 이동

    } catch (error) {
        console.error(error);
        res.status(500).send("댓글 작성 오류");
    }
});

// 9. 댓글 삭제
router.post('/:id/comments/:commentId/delete', checkLogin, async (req, res) => {
    try {
        const { id, commentId } = req.params;
        const userId = req.session.user.id;
        const isAdmin = req.session.user.is_admin === 1;

        // 본인 확인
        const [[comment]] = await pool.query('SELECT * FROM comments WHERE id=?', [commentId]);

        if (comment.user_id !== userId && !isAdmin) {
            return res.send(`<script>alert('작성자만 삭제 가능합니다.'); history.back();</script>`);
        }

        await pool.query('DELETE FROM comments WHERE id=?', [commentId]);
        res.redirect(`/posts/${id}`);

    } catch (error) {
        res.status(500).send("댓글 삭제 오류");
    }
});

module.exports = router;