--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.3 (Debian 15.3-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: categorias; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.categorias OWNER TO alumno;

--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.categorias ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categorias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    fecha_registro date DEFAULT CURRENT_DATE
);


ALTER TABLE public.clientes OWNER TO alumno;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.clientes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.clientes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: direcciones; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.direcciones (
    id integer NOT NULL,
    id_cliente integer NOT NULL,
    calle character varying(125) NOT NULL,
    ciudad character varying(80) NOT NULL,
    codigo_postal character varying(10) NOT NULL,
    es_predeterminada boolean DEFAULT false
);


ALTER TABLE public.direcciones OWNER TO alumno;

--
-- Name: direcciones_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.direcciones ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.direcciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: drops; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.drops (
    id integer NOT NULL,
    nombre character varying(65) NOT NULL,
    fecha_lanzamiento timestamp without time zone NOT NULL,
    estado character varying(20) DEFAULT 'proximamente'::character varying,
    CONSTRAINT drops_estado_check CHECK (((estado)::text = ANY ((ARRAY['proximamente'::character varying, 'activo'::character varying, 'finalizado'::character varying])::text[])))
);


ALTER TABLE public.drops OWNER TO alumno;

--
-- Name: drops_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.drops ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.drops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lineas_pedido; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.lineas_pedido (
    id integer NOT NULL,
    id_pedido integer NOT NULL,
    id_variante integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario_venta numeric(10,2) NOT NULL,
    CONSTRAINT lineas_pedido_cantidad_check CHECK ((cantidad > 0))
);


ALTER TABLE public.lineas_pedido OWNER TO alumno;

--
-- Name: lineas_pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.lineas_pedido ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lineas_pedido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pagos; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.pagos (
    id integer NOT NULL,
    id_pedido integer NOT NULL,
    metodo character varying(50) NOT NULL,
    estado_pago character varying(20) DEFAULT 'completado'::character varying,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.pagos OWNER TO alumno;

--
-- Name: pagos_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.pagos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pagos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pedidos; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.pedidos (
    id integer NOT NULL,
    id_cliente integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(30) DEFAULT 'pendiente'::character varying,
    total numeric(12,2) DEFAULT 0 NOT NULL,
    direccion_envio_fijada text NOT NULL
);


ALTER TABLE public.pedidos OWNER TO alumno;

--
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.pedidos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pedidos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: productos; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.productos (
    id integer NOT NULL,
    id_categoria integer NOT NULL,
    id_drop integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE public.productos OWNER TO alumno;

--
-- Name: productos_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.productos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.productos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stock_movimientos; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.stock_movimientos (
    id integer NOT NULL,
    id_variante integer NOT NULL,
    tipo_movimiento character varying(20),
    cantidad integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    motivo text,
    CONSTRAINT stock_movimientos_tipo_movimiento_check CHECK (((tipo_movimiento)::text = ANY ((ARRAY['entrada'::character varying, 'venta'::character varying, 'devolucion'::character varying, 'ajuste'::character varying])::text[])))
);


ALTER TABLE public.stock_movimientos OWNER TO alumno;

--
-- Name: stock_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.stock_movimientos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stock_movimientos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tickets_soporte; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.tickets_soporte (
    id integer NOT NULL,
    id_cliente integer NOT NULL,
    id_pedido integer,
    asunto character varying(200) NOT NULL,
    prioridad character varying(10) DEFAULT 'media'::character varying,
    estado character varying(20) DEFAULT 'abierto'::character varying,
    CONSTRAINT tickets_soporte_prioridad_check CHECK (((prioridad)::text = ANY ((ARRAY['baja'::character varying, 'media'::character varying, 'alta'::character varying])::text[])))
);


ALTER TABLE public.tickets_soporte OWNER TO alumno;

--
-- Name: tickets_soporte_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.tickets_soporte ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tickets_soporte_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: variantes; Type: TABLE; Schema: public; Owner: alumno
--

CREATE TABLE public.variantes (
    id integer NOT NULL,
    id_producto integer NOT NULL,
    sku character varying(50) NOT NULL,
    talla character varying(10) NOT NULL,
    color character varying(30) NOT NULL,
    precio_actual numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    CONSTRAINT variantes_precio_actual_check CHECK ((precio_actual > (0)::numeric)),
    CONSTRAINT variantes_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.variantes OWNER TO alumno;

--
-- Name: variantes_id_seq; Type: SEQUENCE; Schema: public; Owner: alumno
--

ALTER TABLE public.variantes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.variantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.categorias (id, nombre) FROM stdin;
1	Sudaderas
2	Camisetas
3	Accesorios
4	Pantalones
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.clientes (id, nombre, email, password, fecha_registro) FROM stdin;
1	Nil Ojeda	nil@milfshakes.com	hash_admin_secret	2026-05-20
2	Ibai Llanos	ibai@falsa.com	porcinos_secure_pass	2026-05-20
3	David Cánovas	thegrefg@falsa.com	grefg_contador_2026	2026-05-20
4	Gerard Piqué	gerard@falsa.com	kingsleague_boss	2026-05-20
5	Misho Amoli	misho@falsa.com	misho_heavy_weights	2026-05-20
\.


--
-- Data for Name: direcciones; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.direcciones (id, id_cliente, calle, ciudad, codigo_postal, es_predeterminada) FROM stdin;
1	1	Gran Vía 45, Piso 4	Madrid	28013	t
2	2	Avenida Diagonal 99	Barcelona	08001	t
3	3	Carrer del Serrat 12	Andorra la Vella	AD500	t
4	4	Avinguda Corts Catalanes 4	Barcelona	08021	t
5	5	Paseo de la Castellana 110	Madrid	28046	t
\.


--
-- Data for Name: drops; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.drops (id, nombre, fecha_lanzamiento, estado) FROM stdin;
1	Milfshakes OG Collection	2026-01-01 10:00:00	finalizado
2	Summer Drop 26	2026-06-15 20:00:00	activo
3	Winter Cyber Punk	2026-11-15 12:00:00	proximamente
4	Secret Collab Nil & Misho	2026-03-20 18:00:00	finalizado
5	Milfshakes X Misho Collab	2026-02-14 18:00:00	finalizado
6	Winter Drop 26	2026-12-01 00:00:00	proximamente
7	Milfshakes OG	2026-01-01 10:00:00	finalizado
8	Summer Drop 26	2026-06-15 20:00:00	activo
\.


--
-- Data for Name: lineas_pedido; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.lineas_pedido (id, id_pedido, id_variante, cantidad, precio_unitario_venta) FROM stdin;
1	1	1	1	59.99
2	1	3	1	29.99
3	2	12	2	69.99
4	2	14	1	9.99
5	3	13	1	69.99
6	1	1	1	59.99
7	1	3	1	29.99
\.


--
-- Data for Name: pagos; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.pagos (id, id_pedido, metodo, estado_pago, fecha) FROM stdin;
1	1	tarjeta	completado	2026-05-20 07:28:12.254107
2	2	paypal	completado	2026-05-20 07:28:12.254107
3	3	tarjeta	completado	2026-05-20 07:28:12.254107
\.


--
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.pedidos (id, id_cliente, fecha, estado, total, direccion_envio_fijada) FROM stdin;
1	2	2026-05-10 14:30:00	entregado	89.98	Avenida Diagonal 99, Barcelona, CP 08001
2	3	2026-05-20 07:28:09.370431	enviado	149.97	Carrer del Serrat 12, Andorra la Vella
3	5	2026-05-20 07:28:09.370431	entregado	69.99	Paseo de la Castellana 110, Madrid
4	2	2026-05-20 07:28:38.550677	entregado	89.98	Calle Falsa 123, Madrid
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.productos (id, id_categoria, id_drop, nombre, descripcion) FROM stdin;
1	1	1	Sudadera Classic Cream	La sudadera original de Milfshakes en color crema.
2	2	2	Camiseta Logo Verano	Camiseta ligera de algodón orgánico.
3	3	1	Gorra OG Black	Gorra con el logo clásico bordado.
4	2	2	Camiseta Oversize Black	Corte ancho premium, 240 GSM.
5	3	2	Calcetines Milfshakes Pack	Pack de 3 pares de calcetines altos.
6	4	4	Pantalón Cargo Technical	Pantalón con bolsillos tácticos.
7	4	2	Pantalón Cargo Beige	Pantalón cargo de corte recto multibolsillos.
8	1	5	Sudadera Boxy Cyber	Sudadera de corte boxy con gráficos reflectantes.
9	3	2	Llavero Milfshakes OG	Llavero de goma con el logo clásico.
10	1	1	Sudadera Classic Cream	La sudadera original de Milfshakes
11	2	2	Camiseta Logo Verano	Camiseta ligera para el calor
12	3	1	Gorra OG Black	Gorra con logo bordado
\.


--
-- Data for Name: stock_movimientos; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.stock_movimientos (id, id_variante, tipo_movimiento, cantidad, fecha, motivo) FROM stdin;
1	1	entrada	100	2026-05-20 07:28:23.590507	Recepción de stock de fábrica para el lanzamiento OG
2	14	entrada	500	2026-05-20 07:28:23.590507	Recepción masiva de llaveros de goma desde proveedor
3	13	ajuste	-1	2026-05-20 07:28:23.590507	Unidad de exposición en oficina dañada por uso
\.


--
-- Data for Name: tickets_soporte; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.tickets_soporte (id, id_cliente, id_pedido, asunto, prioridad, estado) FROM stdin;
1	2	1	¿Cuándo llega el repartidor a Barcelona?	media	abierto
2	3	2	El paquete está retenido en la aduana de Andorra	alta	abierto
3	4	\N	¿Vais a reponer las sudaderas Classic en talla L?	baja	resuelto
\.


--
-- Data for Name: variantes; Type: TABLE DATA; Schema: public; Owner: alumno
--

COPY public.variantes (id, id_producto, sku, talla, color, precio_actual, stock) FROM stdin;
1	1	SUD-CR-M	M	Crema	59.99	50
2	1	SUD-CR-L	L	Crema	59.99	0
3	2	CAM-VG-S	S	Blanco	29.99	100
4	2	CAM-VG-M	M	Blanco	29.99	85
5	4	CAM-OV-BK-M	M	Negro	34.99	40
6	4	CAM-OV-BK-L	L	Negro	34.99	60
7	5	CAL-OG-UNI	Única	Blanco	14.99	200
8	6	CAR-BL-M	M	Negro	79.99	30
9	6	CAR-BL-L	L	Negro	79.99	25
10	7	CAR-BE-M	M	Beige	64.99	45
11	7	CAR-BE-L	L	Beige	64.99	50
12	8	SUD-CY-L	L	Gris	69.99	15
13	8	SUD-CY-XL	XL	Gris	69.99	5
14	9	KEY-OG-UNI	Única	Negro	9.99	500
15	2	CAM-VG-L	L	Blanco	29.99	40
16	1	SUD-CR-M	M	Crema	59.99	50
17	1	SUD-CR-L	L	Crema	59.99	0
18	2	CAM-VG-S	S	Blanco	29.99	100
19	2	CAM-VG-M	M	Blanco	29.99	85
\.


--
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.categorias_id_seq', 5, true);


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.clientes_id_seq', 6, true);


--
-- Name: direcciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.direcciones_id_seq', 5, true);


--
-- Name: drops_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.drops_id_seq', 8, true);


--
-- Name: lineas_pedido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.lineas_pedido_id_seq', 7, true);


--
-- Name: pagos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.pagos_id_seq', 3, true);


--
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 4, true);


--
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.productos_id_seq', 12, true);


--
-- Name: stock_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.stock_movimientos_id_seq', 3, true);


--
-- Name: tickets_soporte_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.tickets_soporte_id_seq', 3, true);


--
-- Name: variantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumno
--

SELECT pg_catalog.setval('public.variantes_id_seq', 19, true);


--
-- Name: categorias categorias_nombre_key; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_nombre_key UNIQUE (nombre);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: clientes clientes_email_key; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_email_key UNIQUE (email);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: direcciones direcciones_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_pkey PRIMARY KEY (id);


--
-- Name: drops drops_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.drops
    ADD CONSTRAINT drops_pkey PRIMARY KEY (id);


--
-- Name: lineas_pedido lineas_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.lineas_pedido
    ADD CONSTRAINT lineas_pedido_pkey PRIMARY KEY (id);


--
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id);


--
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- Name: stock_movimientos stock_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.stock_movimientos
    ADD CONSTRAINT stock_movimientos_pkey PRIMARY KEY (id);


--
-- Name: tickets_soporte tickets_soporte_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.tickets_soporte
    ADD CONSTRAINT tickets_soporte_pkey PRIMARY KEY (id);


--
-- Name: variantes variantes_pkey; Type: CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.variantes
    ADD CONSTRAINT variantes_pkey PRIMARY KEY (id);


--
-- Name: direcciones direcciones_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id) ON DELETE CASCADE;


--
-- Name: lineas_pedido lineas_pedido_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.lineas_pedido
    ADD CONSTRAINT lineas_pedido_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes(id);


--
-- Name: pedidos pedidos_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id);


--
-- Name: productos productos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id);


--
-- Name: productos productos_id_drop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_drop_fkey FOREIGN KEY (id_drop) REFERENCES public.drops(id);


--
-- Name: stock_movimientos stock_movimientos_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.stock_movimientos
    ADD CONSTRAINT stock_movimientos_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes(id) ON DELETE CASCADE;


--
-- Name: tickets_soporte tickets_soporte_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.tickets_soporte
    ADD CONSTRAINT tickets_soporte_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id) ON DELETE CASCADE;


--
-- Name: variantes variantes_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumno
--

ALTER TABLE ONLY public.variantes
    ADD CONSTRAINT variantes_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- Name: SEQUENCE categorias_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.categorias_id_seq TO rol_gerente;


--
-- Name: SEQUENCE clientes_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.clientes_id_seq TO rol_gerente;


--
-- Name: SEQUENCE direcciones_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.direcciones_id_seq TO rol_gerente;


--
-- Name: SEQUENCE drops_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.drops_id_seq TO rol_gerente;


--
-- Name: SEQUENCE lineas_pedido_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.lineas_pedido_id_seq TO rol_gerente;


--
-- Name: SEQUENCE pagos_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.pagos_id_seq TO rol_gerente;


--
-- Name: SEQUENCE productos_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.productos_id_seq TO rol_gerente;


--
-- Name: SEQUENCE stock_movimientos_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.stock_movimientos_id_seq TO rol_gerente;


--
-- Name: SEQUENCE tickets_soporte_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.tickets_soporte_id_seq TO rol_gerente;


--
-- Name: SEQUENCE variantes_id_seq; Type: ACL; Schema: public; Owner: alumno
--

GRANT ALL ON SEQUENCE public.variantes_id_seq TO rol_gerente;


--
-- PostgreSQL database dump complete
--

