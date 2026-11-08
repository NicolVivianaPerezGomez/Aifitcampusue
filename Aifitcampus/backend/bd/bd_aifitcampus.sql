--
-- PostgreSQL database dump
--

\restrict UFXS7npZ0zcuOzIQfcd1eEY54NEgPeyo4pg07UKqOjiaRHSM7bOmrIFRkVumbRq

-- Dumped from database version 16.15
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-07 15:43:02

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16936)
-- Name: audits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audits (
    id integer NOT NULL,
    user_id integer,
    action character varying(100) NOT NULL,
    entity character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description text
);


ALTER TABLE public.audits OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16942)
-- Name: audits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.audits ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 16943)
-- Name: badges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.badges (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    condition character varying(255),
    target_value integer,
    is_active boolean DEFAULT true
);


ALTER TABLE public.badges OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16949)
-- Name: badges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.badges ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.badges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 16950)
-- Name: exercise_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exercise_categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true
);


ALTER TABLE public.exercise_categories OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16956)
-- Name: exercise_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.exercise_categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.exercise_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 16957)
-- Name: exercise_routines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exercise_routines (
    id integer NOT NULL,
    routine_id integer NOT NULL,
    exercise_id integer NOT NULL,
    order_index integer NOT NULL,
    sets integer,
    reps integer,
    rest_seconds integer
);


ALTER TABLE public.exercise_routines OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16960)
-- Name: exercise_routines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.exercise_routines ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.exercise_routines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 16961)
-- Name: exercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exercises (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    duration_seconds integer,
    category_id integer,
    resource_type character varying(50),
    resource_url text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.exercises OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16969)
-- Name: exercises_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.exercises ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.exercises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 16970)
-- Name: notification_days; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_days (
    notification_id integer NOT NULL,
    day_of_week integer NOT NULL
);


ALTER TABLE public.notification_days OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16973)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    routine_id integer,
    notification_time time without time zone NOT NULL,
    reminde boolean DEFAULT false,
    reminder_minutes integer,
    is_active boolean DEFAULT true,
    notification_date date NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16980)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16981)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16984)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16985)
-- Name: routine_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routine_logs (
    id integer NOT NULL,
    user_id integer,
    routine_id integer,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    completion_percentage numeric(5,2),
    status character varying(50),
    duration_seconds integer
);


ALTER TABLE public.routine_logs OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16988)
-- Name: routine_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.routine_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.routine_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 16989)
-- Name: routine_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routine_types (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true
);


ALTER TABLE public.routine_types OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16995)
-- Name: routine_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.routine_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.routine_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 16996)
-- Name: routines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routines (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    routine_type_id integer,
    total_duration_seconds integer,
    is_active boolean DEFAULT true,
    user_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.routines OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17004)
-- Name: routines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.routines ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.routines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 17005)
-- Name: user_badges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_badges (
    id integer NOT NULL,
    user_id integer NOT NULL,
    badge_id integer NOT NULL,
    earned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    progress numeric(5,2),
    CONSTRAINT user_badges_progress_check CHECK (((progress >= (0)::numeric) AND (progress <= (100)::numeric)))
);


ALTER TABLE public.user_badges OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17010)
-- Name: user_badges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.user_badges ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_badges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 17011)
-- Name: user_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_notifications (
    user_id integer NOT NULL,
    notification_id integer NOT NULL
);


ALTER TABLE public.user_notifications OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17014)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255),
    microsoft_id character varying(255),
    auth_provider character varying(20) DEFAULT 'local'::character varying NOT NULL,
    job_title character varying(150),
    department character varying(150),
    office_location character varying(150),
    mobile_phone character varying(50),
    business_phones text,
    permissions json,
    role_id integer NOT NULL,
    program_id integer NOT NULL,
    status_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17021)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5009 (class 0 OID 16936)
-- Dependencies: 215
-- Data for Name: audits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audits (id, user_id, action, entity, created_at, description) FROM stdin;
4	\N	CREATE	roles	2026-09-28 01:17:51.021667	Rol creado: Talento humano
5	\N	CREATE	users	2026-09-28 01:18:21.817106	Usuario creado: ana.gomez@uniempresarial.edu.co
6	\N	CREATE	exercises	2026-09-28 05:10:03.350481	Ejercicio creado: Estiramiento de ojos (id 2)
7	6	CREATE	exercise_categories	2026-09-28 07:31:57.702467	Categoría creada: Piernas (id 3)
8	6	CREATE	exercises	2026-09-28 07:31:57.764075	Ejercicio creado: caminata (id 3)
9	6	CREATE	exercise_categories	2026-09-28 07:42:47.020261	Categoría creada: Cuello (id 4)
10	6	CREATE	exercises	2026-09-28 07:42:47.04834	Ejercicio creado: Estiramiento de cuello (id 4)
11	6	DELETE	exercises	2026-09-28 07:43:25.069125	Ejercicio inactivado: Estiramiento de ojos (id 2)
12	6	CREATE	exercise_categories	2026-09-28 07:46:08.336405	Categoría creada: Ojos (id 5)
13	6	CREATE	exercises	2026-09-28 07:46:08.363037	Ejercicio creado: Movimiento ocular (id 5)
14	\N	CREATE	exercise_categories	2026-09-28 07:52:28.818858	Categoría creada: Brazo (id 6)
15	6	CREATE	routine_types	2026-09-28 08:17:58.252967	Tipo de rutina creado: pausa matutina (id 1)
16	6	CREATE	routines	2026-09-28 08:17:58.338689	Rutina creada: cuerpo completo (id 1)
17	6	CREATE	badges	2026-09-28 09:21:17.087227	Insignia creada: Pausa matutina (id 1)
18	6	DELETE	exercises	2026-09-28 09:38:27.927604	Ejercicio inactivado: caminata (id 3)
19	6	UPDATE	exercises	2026-09-28 09:38:31.037004	Ejercicio actualizado: caminata (id 3)
20	6	DELETE	exercises	2026-09-28 09:38:32.406596	Ejercicio inactivado: caminata (id 3)
21	6	UPDATE	exercises	2026-09-28 09:38:34.008229	Ejercicio actualizado: caminata (id 3)
22	6	UPDATE	exercises	2026-09-28 09:54:35.664903	Ejercicio actualizado: caminata (id 3)
23	6	UPDATE	routines	2026-09-28 09:55:13.375272	Rutina actualizada: cuerpo completo (id 1)
24	6	UPDATE	badges	2026-09-28 09:55:51.842053	Insignia actualizada: Pausa matutina (id 1)
25	6	CREATE	users	2026-09-28 10:08:21.18002	Usuario creado: squintero@uniempresarial.edu.co
26	6	DEACTIVATE	users	2026-09-28 10:33:32.265528	Usuario inactivado: ana.gomez@uniempresarial.edu.co (id 2)
27	6	ACTIVATE	users	2026-09-28 10:39:11.087046	Usuario reactivado: ana.gomez@uniempresarial.edu.co (id 2)
28	6	DEACTIVATE	users	2026-09-28 10:42:19.009376	Usuario inactivado: ana.gomez@uniempresarial.edu.co (id 2)
29	6	ACTIVATE	users	2026-09-28 10:42:21.45446	Usuario reactivado: ana.gomez@uniempresarial.edu.co (id 2)
30	6	UPDATE	users	2026-09-28 10:42:26.55076	Usuario 2 reasignado al rol usuario (id 2)
32	6	UPDATE	exercises	2026-09-28 13:39:49.99249	Ejercicio actualizado: Estiramiento de ojos (id 2)
\.


--
-- TOC entry 5011 (class 0 OID 16943)
-- Dependencies: 217
-- Data for Name: badges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.badges (id, name, description, condition, target_value, is_active) FROM stdin;
1	Primera Pausa	Completa la racha de 3	completar las 3 pausas	3	t
\.


--
-- TOC entry 5013 (class 0 OID 16950)
-- Dependencies: 219
-- Data for Name: exercise_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercise_categories (id, name, description, is_active) FROM stdin;
1	Estiramiento	Ejercicios para estirar cuello, espalda y brazos	t
2	Movilidad	Ejercicios de movilidad articular	t
3	Piernas	\N	t
4	Cuello	\N	t
5	Ojos	\N	t
6	Brazo	Ejercicios para el brazo	t
\.


--
-- TOC entry 5015 (class 0 OID 16957)
-- Dependencies: 221
-- Data for Name: exercise_routines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercise_routines (id, routine_id, exercise_id, order_index, sets, reps, rest_seconds) FROM stdin;
4	1	3	1	\N	\N	\N
5	1	4	2	\N	\N	\N
6	1	5	3	\N	\N	\N
\.


--
-- TOC entry 5017 (class 0 OID 16961)
-- Dependencies: 223
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercises (id, name, description, duration_seconds, category_id, resource_type, resource_url, is_active, created_at, updated_at) FROM stdin;
4	Estiramiento de cuello	Estiramiento cuello y cervical	60	4	video	http://localhost:4000/videos/Cuello.mp4	t	2026-09-28 07:42:47.038353	2026-09-28 07:42:47.038353
5	Movimiento ocular	descanso visual	60	5	video	http://localhost:4000/videos/ocular.mp4	t	2026-09-28 07:46:08.351439	2026-09-28 07:46:08.351439
3	caminata	En tu sitio camina despacio	60	3	video	http://localhost:4000/videos/caminata.mp4	t	2026-09-28 07:31:57.747972	2026-09-28 09:54:35.63
2	Estiramiento de ojos	Mueve los ojos hacia cada lado, mantén 15 segundos por lado	60	1	video	http://localhost:4000/videos/ocular.mp4	t	2026-09-28 05:10:03.332903	2026-09-28 13:39:49.972
\.


--
-- TOC entry 5019 (class 0 OID 16970)
-- Dependencies: 225
-- Data for Name: notification_days; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_days (notification_id, day_of_week) FROM stdin;
2	1
2	4
3	1
3	2
3	5
10	1
10	2
10	5
11	1
11	5
1	1
1	5
\.


--
-- TOC entry 5020 (class 0 OID 16973)
-- Dependencies: 226
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, name, description, routine_id, notification_time, reminde, reminder_minutes, is_active, notification_date) FROM stdin;
1	Pausa activa de la mañana	Realizar ejercicios de estiramiento durante la jornada laboral.	1	09:00:00	t	10	f	2026-11-15
3	Pausa activa de la tarde	Realizar ejercicios de estiramiento durante la jornada.	1	09:00:00	t	10	t	2026-11-15
10	Pausa activa de la tardeee	Realizar ejercicios de estiramiento durante la jornada.	1	09:00:00	t	10	t	2026-11-15
11	Ejemplo pausa activa	tgrtgh	1	20:29:00	t	5	t	2026-11-15
2	Ejemplo	Ejemplo de prueba para notificación	1	11:25:00	t	10	f	2026-11-15
\.


--
-- TOC entry 5022 (class 0 OID 16981)
-- Dependencies: 228
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
1	Talento humano
2	usuario
3	admin
\.


--
-- TOC entry 5024 (class 0 OID 16985)
-- Dependencies: 230
-- Data for Name: routine_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.routine_logs (id, user_id, routine_id, started_at, ended_at, completion_percentage, status, duration_seconds) FROM stdin;
\.


--
-- TOC entry 5026 (class 0 OID 16989)
-- Dependencies: 232
-- Data for Name: routine_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.routine_types (id, name, description, is_active) FROM stdin;
1	pausa matutina	\N	t
\.


--
-- TOC entry 5028 (class 0 OID 16996)
-- Dependencies: 234
-- Data for Name: routines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.routines (id, name, description, routine_type_id, total_duration_seconds, is_active, user_id, created_at, updated_at) FROM stdin;
1	cuerpo completo	Estiramiento de todas las extremidades	1	180	t	6	2026-09-28 08:17:58.285918	2026-09-28 09:55:13.307
\.


--
-- TOC entry 5030 (class 0 OID 17005)
-- Dependencies: 236
-- Data for Name: user_badges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_badges (id, user_id, badge_id, earned_at, progress) FROM stdin;
\.


--
-- TOC entry 5032 (class 0 OID 17011)
-- Dependencies: 238
-- Data for Name: user_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_notifications (user_id, notification_id) FROM stdin;
\.


--
-- TOC entry 5033 (class 0 OID 17014)
-- Dependencies: 239
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, email, password, microsoft_id, auth_provider, job_title, department, office_location, mobile_phone, business_phones, permissions, role_id, program_id, status_id, created_at) FROM stdin;
2	Ana	Gómez	ana.gomez@uniempresarial.edu.co	\N	\N	local	\N	Talento Humano	Sede principal	\N	\N	\N	2	1	1	2026-09-28 01:18:21.775679
6	Nicol Viviana	Perez Gomez	nperez@uniempresarial.edu.co	$2b$10$d5ruhYJRY04Em5blfJ/mXejFm4Wnt5mmsrzgZFdtcEDPHPkTObslu	54a234f0-9af4-4c40-b76e-0ec85c00c49a	microsoft	Estudiante de  ingeniería de software	\N	Uniempresarial	\N	["3808000"]	\N	3	1	1	2026-09-28 04:35:49.101327
8	Test	User	test@uniempresarial.edu.co	$2b$10$nR1wPoMCY1Tc0Cqn2BxfmuIoscziI69LMk6J0ThVMgXlFbY5yeTCy	\N	local	\N	\N	\N	\N	\N	\N	2	1	1	2026-09-28 12:09:34.616611
7	Sara Lorena	Quintero Salamanca	squintero@uniempresarial.edu.co	\N	c88f1068-8128-4b97-b3bd-f588ad910a04	microsoft	Estudiante de Ingeniería de Software	Estudiante	Uniempresarial	\N	["3808000"]	\N	3	2	1	2026-09-28 10:08:21.163991
\.


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 216
-- Name: audits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audits_id_seq', 32, true);


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 218
-- Name: badges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.badges_id_seq', 1, true);


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 220
-- Name: exercise_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercise_categories_id_seq', 6, true);


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 222
-- Name: exercise_routines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercise_routines_id_seq', 6, true);


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 224
-- Name: exercises_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercises_id_seq', 5, true);


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 227
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 11, true);


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 229
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 231
-- Name: routine_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routine_logs_id_seq', 1, false);


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 233
-- Name: routine_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routine_types_id_seq', 1, true);


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 235
-- Name: routines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routines_id_seq', 1, true);


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 237
-- Name: user_badges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_badges_id_seq', 1, false);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 240
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- TOC entry 4815 (class 2606 OID 17023)
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- TOC entry 4818 (class 2606 OID 17025)
-- Name: badges badges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- TOC entry 4820 (class 2606 OID 17027)
-- Name: exercise_categories exercise_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise_categories
    ADD CONSTRAINT exercise_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 17029)
-- Name: exercise_routines exercise_routines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise_routines
    ADD CONSTRAINT exercise_routines_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 17031)
-- Name: exercise_routines exercise_routines_routine_id_order_index_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise_routines
    ADD CONSTRAINT exercise_routines_routine_id_order_index_key UNIQUE (routine_id, order_index);


--
-- TOC entry 4826 (class 2606 OID 17033)
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);


--
-- TOC entry 4828 (class 2606 OID 17035)
-- Name: notification_days notification_days_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_days
    ADD CONSTRAINT notification_days_pkey PRIMARY KEY (notification_id, day_of_week);


--
-- TOC entry 4830 (class 2606 OID 17037)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4832 (class 2606 OID 17039)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 4834 (class 2606 OID 17041)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 17043)
-- Name: routine_logs routine_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routine_logs
    ADD CONSTRAINT routine_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4838 (class 2606 OID 17045)
-- Name: routine_types routine_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routine_types
    ADD CONSTRAINT routine_types_pkey PRIMARY KEY (id);


--
-- TOC entry 4840 (class 2606 OID 17047)
-- Name: routines routines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routines
    ADD CONSTRAINT routines_pkey PRIMARY KEY (id);


--
-- TOC entry 4842 (class 2606 OID 17049)
-- Name: user_badges user_badges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_pkey PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 17051)
-- Name: user_badges user_badges_user_id_badge_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_user_id_badge_id_key UNIQUE (user_id, badge_id);


--
-- TOC entry 4846 (class 2606 OID 17053)
-- Name: user_notifications user_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT user_notifications_pkey PRIMARY KEY (user_id, notification_id);


--
-- TOC entry 4848 (class 2606 OID 17055)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4850 (class 2606 OID 17057)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 1259 OID 17135)
-- Name: idx_audits_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audits_user_id ON public.audits USING btree (user_id);


--
-- TOC entry 4851 (class 2606 OID 17058)
-- Name: audits audits_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4852 (class 2606 OID 17063)
-- Name: exercise_routines exercise_routines_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise_routines
    ADD CONSTRAINT exercise_routines_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- TOC entry 4853 (class 2606 OID 17068)
-- Name: exercise_routines exercise_routines_routine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise_routines
    ADD CONSTRAINT exercise_routines_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES public.routines(id) ON DELETE CASCADE;


--
-- TOC entry 4854 (class 2606 OID 17073)
-- Name: exercises exercises_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.exercise_categories(id);


--
-- TOC entry 4855 (class 2606 OID 17078)
-- Name: notification_days notification_days_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_days
    ADD CONSTRAINT notification_days_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- TOC entry 4856 (class 2606 OID 17083)
-- Name: notifications notifications_routine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES public.routines(id);


--
-- TOC entry 4857 (class 2606 OID 17088)
-- Name: routine_logs routine_logs_routine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routine_logs
    ADD CONSTRAINT routine_logs_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES public.routines(id);


--
-- TOC entry 4858 (class 2606 OID 17093)
-- Name: routine_logs routine_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routine_logs
    ADD CONSTRAINT routine_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4859 (class 2606 OID 17098)
-- Name: routines routines_routine_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routines
    ADD CONSTRAINT routines_routine_type_id_fkey FOREIGN KEY (routine_type_id) REFERENCES public.routine_types(id);


--
-- TOC entry 4860 (class 2606 OID 17103)
-- Name: routines routines_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routines
    ADD CONSTRAINT routines_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4861 (class 2606 OID 17108)
-- Name: user_badges user_badges_badge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_badge_id_fkey FOREIGN KEY (badge_id) REFERENCES public.badges(id);


--
-- TOC entry 4862 (class 2606 OID 17113)
-- Name: user_badges user_badges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4863 (class 2606 OID 17118)
-- Name: user_notifications user_notifications_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT user_notifications_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- TOC entry 4864 (class 2606 OID 17123)
-- Name: user_notifications user_notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT user_notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4865 (class 2606 OID 17128)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-11-07 15:43:02

--
-- PostgreSQL database dump complete
--

\unrestrict UFXS7npZ0zcuOzIQfcd1eEY54NEgPeyo4pg07UKqOjiaRHSM7bOmrIFRkVumbRq

