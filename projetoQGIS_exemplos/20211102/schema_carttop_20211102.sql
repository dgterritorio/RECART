--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1 (Ubuntu 13.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.2

-- Started on 2021-03-30 09:21:00

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

--
-- TOC entry 8 (class 2615 OID 107245)
-- Name: carttop; Type: SCHEMA; Schema: -; Owner: dgt
--

CREATE SCHEMA carttop;


ALTER SCHEMA carttop OWNER TO dgt;

SET default_tablespace = '';

SET default_table_access_method = heap;



--
-- TOC entry 394 (class 1259 OID 107251)
-- Name: curvas_nivel_mediana; Type: MATERIALIZED VIEW; Schema: carttop; Owner: dgt
--

CREATE MATERIALIZED VIEW carttop.curvas_nivel_mediana AS
 WITH d AS (
         SELECT curva_de_nivel_1.identificador,
            public.st_dumppoints(curva_de_nivel_1.geometria) AS dump
           FROM public.curva_de_nivel curva_de_nivel_1
        ), z AS (
         SELECT d.identificador,
            public.st_z((d.dump).geom) AS z
           FROM d
        ), m AS (
         SELECT percentile_disc((0.5)::double precision) WITHIN GROUP (ORDER BY z.z) AS mediana,
            z.identificador
           FROM z
          GROUP BY z.identificador
        )
 SELECT curva_de_nivel.identificador,
    curva_de_nivel.geometria,
    m.mediana
   FROM (public.curva_de_nivel
     LEFT JOIN m ON ((curva_de_nivel.identificador = m.identificador)))
  WITH NO DATA;


ALTER TABLE carttop.curvas_nivel_mediana OWNER TO dgt;

--
-- TOC entry 395 (class 1259 OID 107259)
-- Name: edificio_nome_edificio; Type: MATERIALIZED VIEW; Schema: carttop; Owner: dgt
--

CREATE MATERIALIZED VIEW carttop.edificio_nome_edificio AS
 SELECT edificio.identificador,
    string_agg((nome_edificio.nome)::text, ' | '::text) AS nome_edificio,
    edificio.valor_forma_edificio,
    edificio.geometria
   FROM (public.edificio
     LEFT JOIN public.nome_edificio ON ((nome_edificio.edificio_id = edificio.identificador)))
  WHERE (((edificio.valor_forma_edificio)::text <> ALL (ARRAY[('27'::character varying)::text, ('4'::character varying)::text])) AND (edificio.valor_forma_edificio IS NOT NULL))
  GROUP BY edificio.identificador, edificio.geometria, nome_edificio.nome
  ORDER BY nome_edificio.nome
  WITH NO DATA;


ALTER TABLE carttop.edificio_nome_edificio OWNER TO dgt;

--
-- TOC entry 396 (class 1259 OID 107267)
-- Name: edificio_valor_utilizacao_atual; Type: MATERIALIZED VIEW; Schema: carttop; Owner: dgt
--

CREATE MATERIALIZED VIEW carttop.edificio_valor_utilizacao_atual AS
 WITH a AS (
         SELECT edificio_1.identificador,
            lig_valor_utilizacao_atual_edificio.valor_utilizacao_atual_id
           FROM (public.edificio edificio_1
             JOIN public.lig_valor_utilizacao_atual_edificio ON ((edificio_1.identificador = lig_valor_utilizacao_atual_edificio.edificio_id)))
          ORDER BY edificio_1.identificador, lig_valor_utilizacao_atual_edificio.valor_utilizacao_atual_id
        ), b AS (
         SELECT a.identificador AS id,
            string_agg((a.valor_utilizacao_atual_id)::text, ' | '::text) AS utilizacao_atual
           FROM a
          GROUP BY a.identificador
        )
 SELECT edificio.identificador,
    edificio.valor_condicao_const,
    b.utilizacao_atual,
    edificio.geometria
   FROM (public.edificio
     LEFT JOIN b ON ((edificio.identificador = b.id)))
  WITH NO DATA;


ALTER TABLE carttop.edificio_valor_utilizacao_atual OWNER TO dgt;

--
-- TOC entry 402 (class 1259 OID 120864)
-- Name: nome_geometria_adm_publica; Type: MATERIALIZED VIEW; Schema: carttop; Owner: dgt
--

CREATE MATERIALIZED VIEW carttop.nome_geometria_adm_publica
TABLESPACE pg_default
AS WITH ap AS (
         SELECT adm_publica.identificador AS id,
            adm_publica.nome,
            valor_tipo_adm_publica.descricao,
            edificio.geometria AS geom
           FROM public.adm_publica
             JOIN public.lig_adm_publica_edificio ON adm_publica.identificador = lig_adm_publica_edificio.adm_publica_id
             LEFT JOIN public.valor_tipo_adm_publica ON valor_tipo_adm_publica.identificador::text = adm_publica.valor_tipo_adm_publica::text
             LEFT JOIN public.edificio ON lig_adm_publica_edificio.edificio_id = edificio.identificador
          WHERE public.st_geometrytype(edificio.geometria) = 'ST_Polygon'::text
        )
 SELECT ap.id,
    ap.nome,
    ap.descricao,
    public.st_union(ap.geom) AS geometria
   FROM ap
  GROUP BY ap.id, ap.nome, ap.descricao
WITH DATA;


ALTER TABLE carttop.nome_geometria_adm_publica OWNER TO dgt;

--
-- TOC entry 397 (class 1259 OID 107275)
-- Name: nome_geometria_equip_util_coletiva; Type: MATERIALIZED VIEW; Schema: carttop; Owner: dgt
--

CREATE MATERIALIZED VIEW carttop.nome_geometria_equip_util_coletiva
TABLESPACE pg_default
AS WITH euc AS (
         SELECT equip_util_coletiva.identificador AS id,
            equip_util_coletiva.nome,
            edificio.geometria AS geom
           FROM public.equip_util_coletiva
             JOIN public.lig_equip_util_coletiva_edificio ON equip_util_coletiva.identificador = lig_equip_util_coletiva_edificio.equip_util_coletiva_id
             LEFT JOIN public.edificio ON lig_equip_util_coletiva_edificio.edificio_id = edificio.identificador
          WHERE public.st_geometrytype(edificio.geometria) = 'ST_Polygon'::text
        UNION
         SELECT equip_util_coletiva.identificador AS id,
            equip_util_coletiva.nome,
            areas_artificializadas.geometria AS geom
           FROM public.equip_util_coletiva
             JOIN public.areas_artificializadas ON equip_util_coletiva.identificador = areas_artificializadas.equip_util_coletiva_id
        ), eucg AS (
         SELECT euc.id,
            euc.nome,
            public.st_union(euc.geom) AS geometria
           FROM euc
          GROUP BY euc.id, euc.nome
        ), a AS (
         SELECT equip_util_coletiva.identificador,
            valor_tipo_equipamento_coletivo.descricao AS descri
           FROM public.equip_util_coletiva
             JOIN public.lig_valor_tipo_equipamento_coletivo_equip_util_coletiva ON equip_util_coletiva.identificador = lig_valor_tipo_equipamento_coletivo_equip_util_coletiva.equip_util_coletiva_id
             JOIN public.valor_tipo_equipamento_coletivo ON lig_valor_tipo_equipamento_coletivo_equip_util_coletiva.valor_tipo_equipamento_coletivo_id::text = valor_tipo_equipamento_coletivo.identificador::text
          ORDER BY equip_util_coletiva.*, valor_tipo_equipamento_coletivo.descricao
        ), eucv AS (
         SELECT a.identificador,
            string_agg(a.descri::text, ' | '::text) AS descricao
           FROM a
          GROUP BY a.identificador
        )
 SELECT eucv.identificador as id,
    eucg.nome,
    eucv.descricao,
    eucg.geometria
   FROM eucg
     LEFT JOIN eucv ON eucg.id = eucv.identificador
WITH DATA;


ALTER TABLE carttop.nome_geometria_equip_util_coletiva OWNER TO dgt;

--
-- TOC entry 401 (class 1259 OID 120850)
-- Name: nome_geometria_inst_gestao_ambiental; Type: MATERIALIZED VIEW; Schema: carttop; Owner: dgt
--

CREATE MATERIALIZED VIEW carttop.nome_geometria_inst_gestao_ambiental
TABLESPACE pg_default
AS WITH iga AS (
         SELECT inst_gestao_ambiental.identificador AS id,
            inst_gestao_ambiental.nome,
            inst_gestao_ambiental.valor_instalacao_gestao_ambiental,
            edificio.geometria AS geom
           FROM public.inst_gestao_ambiental
             JOIN public.edificio ON edificio.inst_gestao_ambiental_id = inst_gestao_ambiental.identificador
          WHERE public.st_geometrytype(edificio.geometria) = 'ST_Polygon'::text
        UNION
         SELECT inst_gestao_ambiental.identificador AS id,
            inst_gestao_ambiental.nome,
            inst_gestao_ambiental.valor_instalacao_gestao_ambiental,
            areas_artificializadas.geometria AS geom
           FROM public.inst_gestao_ambiental
             JOIN public.areas_artificializadas ON inst_gestao_ambiental.identificador = areas_artificializadas.inst_gestao_ambiental_id
        ), igav AS (
         SELECT iga.id,
            iga.nome,
            valor_instalacao_gestao_ambiental.descricao,
            iga.geom
           FROM iga
             LEFT JOIN public.valor_instalacao_gestao_ambiental ON valor_instalacao_gestao_ambiental.identificador::text = iga.valor_instalacao_gestao_ambiental::text
        )
 SELECT igav.id,
    igav.nome,
    igav.descricao,
    public.st_union(igav.geom) AS geometria
   FROM igav
  GROUP BY igav.id, igav.nome, igav.descricao
WITH DATA;


ALTER TABLE carttop.nome_geometria_inst_gestao_ambiental OWNER TO dgt;

--
-- TOC entry 400 (class 1259 OID 120833)
-- Name: nome_geometria_inst_producao; Type: MATERIALIZED VIEW; Schema: carttop; Owner: dgt
--
CREATE MATERIALIZED VIEW carttop.nome_geometria_inst_producao
TABLESPACE pg_default
AS WITH ip AS (
         SELECT inst_producao.identificador AS id,
            inst_producao.nome,
            inst_producao.valor_instalacao_producao,
            edificio.geometria AS geom
           FROM public.inst_producao
             JOIN public.edificio ON edificio.inst_producao_id = inst_producao.identificador
          WHERE public.st_geometrytype(edificio.geometria) = 'ST_Polygon'::text
        UNION
         SELECT inst_producao.identificador AS id,
            inst_producao.nome,
            inst_producao.valor_instalacao_producao,
            areas_artificializadas.geometria AS geom
           FROM public.inst_producao
             JOIN public.areas_artificializadas ON inst_producao.identificador = areas_artificializadas.inst_producao_id
        ), ipv AS (
         SELECT ip.id,
            ip.nome,
            valor_instalacao_producao.descricao,
            ip.geom
           FROM ip
             LEFT JOIN public.valor_instalacao_producao ON valor_instalacao_producao.identificador::text = ip.valor_instalacao_producao::text
        )
 SELECT ipv.id,
    ipv.nome,
    ipv.descricao,
    public.st_union(ipv.geom) AS geometria
   FROM ipv
  GROUP BY ipv.id, ipv.nome, ipv.descricao
WITH DATA;


ALTER TABLE carttop.nome_geometria_inst_producao OWNER TO dgt;

--
-- TOC entry 398 (class 1259 OID 107283)
-- Name: nomes_seg_via_rodov; Type: MATERIALIZED VIEW; Schema: carttop; Owner: dgt
--

CREATE MATERIALIZED VIEW carttop.nomes_seg_via_rodov AS
 WITH a AS (
         SELECT seg_via_rodov.identificador,
            via_rodov.nome
           FROM ((public.seg_via_rodov
             JOIN public.lig_segviarodov_viarodov ON ((seg_via_rodov.identificador = lig_segviarodov_viarodov.seg_via_rodov_id)))
             JOIN public.via_rodov ON ((via_rodov.identificador = lig_segviarodov_viarodov.via_rodov_id)))
          ORDER BY seg_via_rodov.identificador, via_rodov.nome
        )
 SELECT a.identificador,
    string_agg((a.nome)::text, ' | '::text) AS nome_ou_nomes
   FROM a
  GROUP BY a.identificador
  WITH NO DATA;


ALTER TABLE carttop.nomes_seg_via_rodov OWNER TO dgt;

-- carttop.nomes_seg_via_ferrea source

CREATE MATERIALIZED VIEW carttop.nomes_seg_via_ferrea
TABLESPACE pg_default
AS WITH a AS (
         SELECT seg_via_ferrea.identificador,
            linha_ferrea.nome
           FROM public.seg_via_ferrea
             JOIN public.lig_segviaferrea_linhaferrea ON public.seg_via_ferrea.identificador = public.lig_segviaferrea_linhaferrea.seg_via_ferrea_id
             JOIN public.linha_ferrea ON public.linha_ferrea.identificador = public.lig_segviaferrea_linhaferrea.linha_ferrea_id
          ORDER BY seg_via_ferrea.identificador, linha_ferrea.nome
        )
 SELECT a.identificador,
    string_agg(a.nome::text, ' | '::text) AS nome_ou_nomes
   FROM a
  GROUP BY a.identificador
WITH DATA;

--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA carttop; Type: ACL; Schema: -; Owner: dgt
--

GRANT USAGE ON SCHEMA carttop TO userdgt_leitura;
GRANT USAGE ON SCHEMA carttop TO userdgt_escrita;



--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 394
-- Name: TABLE curvas_nivel_mediana; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.curvas_nivel_mediana TO userdgt_leitura;
GRANT ALL ON TABLE carttop.curvas_nivel_mediana TO userdgt_escrita;


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 395
-- Name: TABLE edificio_nome_edificio; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.edificio_nome_edificio TO userdgt_leitura;
GRANT ALL ON TABLE carttop.edificio_nome_edificio TO userdgt_escrita;


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 396
-- Name: TABLE edificio_valor_utilizacao_atual; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.edificio_valor_utilizacao_atual TO userdgt_leitura;
GRANT ALL ON TABLE carttop.edificio_valor_utilizacao_atual TO userdgt_escrita;


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE nome_geometria_adm_publica; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.nome_geometria_adm_publica TO userdgt_leitura;
GRANT ALL ON TABLE carttop.nome_geometria_adm_publica TO userdgt_escrita;


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 397
-- Name: TABLE nome_geometria_equip_util_coletiva; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.nome_geometria_equip_util_coletiva TO userdgt_leitura;
GRANT ALL ON TABLE carttop.nome_geometria_equip_util_coletiva TO userdgt_escrita;


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 401
-- Name: TABLE nome_geometria_inst_gestao_ambiental; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.nome_geometria_inst_gestao_ambiental TO userdgt_leitura;
GRANT ALL ON TABLE carttop.nome_geometria_inst_gestao_ambiental TO userdgt_escrita;


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE nome_geometria_inst_producao; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.nome_geometria_inst_producao TO userdgt_leitura;
GRANT ALL ON TABLE carttop.nome_geometria_inst_producao TO userdgt_escrita;


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE nomes_seg_via_rodov; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.nomes_seg_via_rodov TO userdgt_leitura;
GRANT ALL ON TABLE carttop.nomes_seg_via_rodov TO userdgt_escrita;

--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE nomes_seg_via_ferrea; Type: ACL; Schema: carttop; Owner: dgt
--

GRANT SELECT,UPDATE ON TABLE carttop.nomes_seg_via_ferrea TO userdgt_leitura;
GRANT ALL ON TABLE carttop.nomes_seg_via_ferrea TO userdgt_escrita;

--
-- TOC entry 5061 (class 0 OID 107251)
-- Dependencies: 394 5073
-- Name: curvas_nivel_mediana; Type: MATERIALIZED VIEW DATA; Schema: carttop; Owner: dgt
--

REFRESH MATERIALIZED VIEW carttop.curvas_nivel_mediana;


--
-- TOC entry 5062 (class 0 OID 107259)
-- Dependencies: 395 5073
-- Name: edificio_nome_edificio; Type: MATERIALIZED VIEW DATA; Schema: carttop; Owner: dgt
--

REFRESH MATERIALIZED VIEW carttop.edificio_nome_edificio;


--
-- TOC entry 5063 (class 0 OID 107267)
-- Dependencies: 396 5073
-- Name: edificio_valor_utilizacao_atual; Type: MATERIALIZED VIEW DATA; Schema: carttop; Owner: dgt
--

REFRESH MATERIALIZED VIEW carttop.edificio_valor_utilizacao_atual;


--
-- TOC entry 5069 (class 0 OID 120864)
-- Dependencies: 402 5073
-- Name: nome_geometria_adm_publica; Type: MATERIALIZED VIEW DATA; Schema: carttop; Owner: dgt
--

REFRESH MATERIALIZED VIEW carttop.nome_geometria_adm_publica;


--
-- TOC entry 5064 (class 0 OID 107275)
-- Dependencies: 397 5073
-- Name: nome_geometria_equip_util_coletiva; Type: MATERIALIZED VIEW DATA; Schema: carttop; Owner: dgt
--

REFRESH MATERIALIZED VIEW carttop.nome_geometria_equip_util_coletiva;


--
-- TOC entry 5068 (class 0 OID 120850)
-- Dependencies: 401 5073
-- Name: nome_geometria_inst_gestao_ambiental; Type: MATERIALIZED VIEW DATA; Schema: carttop; Owner: dgt
--

REFRESH MATERIALIZED VIEW carttop.nome_geometria_inst_gestao_ambiental;


--
-- TOC entry 5067 (class 0 OID 120833)
-- Dependencies: 400 5073
-- Name: nome_geometria_inst_producao; Type: MATERIALIZED VIEW DATA; Schema: carttop; Owner: dgt
--

REFRESH MATERIALIZED VIEW carttop.nome_geometria_inst_producao;


--
-- TOC entry 5065 (class 0 OID 107283)
-- Dependencies: 398 5073
-- Name: nomes_seg_via_rodov; Type: MATERIALIZED VIEW DATA; Schema: carttop; Owner: dgt
--

REFRESH MATERIALIZED VIEW carttop.nomes_seg_via_rodov;


-- Completed on 2021-03-30 09:21:01

--
-- PostgreSQL database dump complete
--

