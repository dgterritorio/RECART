/**
 * Para executar o script executar `psql -f recart.ddl -U postgres postgres`
 */

/**
 * Criar base de dados em Windows
 */

CREATE DATABASE recart WITH ENCODING 'UTF8' LC_COLLATE='Portuguese_Portugal' LC_CTYPE='Portuguese_Portugal' TEMPLATE='template0';

/**
 * Criar base de dados em Linux

CREATE DATABASE recart WITH ENCODING 'UTF8' LC_COLLATE='pt_PT.UTF-8' LC_CTYPE='pt_PT.UTF-8' TEMPLATE='template0';
 */

/**
 * Conectar a base de dados recart
 */

\c recart

/**
 * Instalar extensão PostGIS
 */

CREATE EXTENSION "postgis";

/**
 * Instalar extensão UUID
 */

CREATE EXTENSION "uuid-ossp";

/**
 * Criar dominio Toponimia
 */
CREATE TABLE designacao_local (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_local_nomeado varchar(10) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','designacao_local','geometria',3763,'POINT',2);
ALTER TABLE designacao_local ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_local_nomeado (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE designacao_local ADD CONSTRAINT valor_local_nomeado_id FOREIGN KEY (valor_local_nomeado) REFERENCES valor_local_nomeado (identificador);

/**
 * Criar dominio Ocupação de Solo
 */

CREATE TABLE area_agricola_florestal_mato (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_areas_agricolas_florestais_matos varchar(10) NOT NULL,
	nome varchar(255),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','area_agricola_florestal_mato','geometria',3763,'POLYGON',2);
ALTER TABLE area_agricola_florestal_mato ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE areas_artificializadas (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	inst_producao_id uuid,
	inst_gestao_ambiental_id uuid,
	equip_util_coletiva_id uuid,
	valor_areas_artificializadas varchar(10) NOT NULL,
	nome varchar(255),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','areas_artificializadas','geometria',3763,'POLYGON',2);
ALTER TABLE areas_artificializadas ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_areas_agricolas_florestais_matos (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_areas_artificializadas (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE area_agricola_florestal_mato ADD CONSTRAINT valor_areas_agricolas_florestais_matos_id FOREIGN KEY (valor_areas_agricolas_florestais_matos) REFERENCES valor_areas_agricolas_florestais_matos (identificador);
ALTER TABLE areas_artificializadas ADD CONSTRAINT valor_areas_artificializadas_id FOREIGN KEY (valor_areas_artificializadas) REFERENCES valor_areas_artificializadas (identificador);

/**
 * Criar dominio Altimetria
 */

CREATE TABLE linha_de_quebra (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_classifica varchar(10) NOT NULL,
	valor_natureza_linha varchar(10) NOT NULL,
	artificial bool,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','linha_de_quebra','geometria',3763,'LINESTRING',3);
ALTER TABLE linha_de_quebra ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE ponto_cotado (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_classifica_las varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','ponto_cotado','geometria',3763,'POINT',3);
ALTER TABLE ponto_cotado ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE curva_de_nivel (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_tipo_curva varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','curva_de_nivel','geometria',3763,'LINESTRING',3);
ALTER TABLE curva_de_nivel ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_tipo_curva (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_natureza_linha (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_classifica_las (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_classifica (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE linha_de_quebra ADD CONSTRAINT valor_classifica_id FOREIGN KEY (valor_classifica) REFERENCES valor_classifica (identificador);
ALTER TABLE linha_de_quebra ADD CONSTRAINT valor_natureza_linha_id FOREIGN KEY (valor_natureza_linha) REFERENCES valor_natureza_linha (identificador);
ALTER TABLE ponto_cotado ADD CONSTRAINT valor_classifica_las_id FOREIGN KEY (valor_classifica_las) REFERENCES valor_classifica_las (identificador);
ALTER TABLE curva_de_nivel ADD CONSTRAINT valor_tipo_curva_id FOREIGN KEY (valor_tipo_curva) REFERENCES valor_tipo_curva (identificador);

/**
 * Criar dominio Mobiliário Urbano
 */

-- Ponto, Poligono
CREATE TABLE mob_urbano_sinal (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_tipo_de_mob_urbano_sinal varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','mob_urbano_sinal','geometria',3763,'GEOMETRY',2);
ALTER TABLE mob_urbano_sinal ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_tipo_de_mob_urbano_sinal (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE mob_urbano_sinal ADD CONSTRAINT valor_tipo_de_mob_urbano_sinal_id FOREIGN KEY (valor_tipo_de_mob_urbano_sinal) REFERENCES valor_tipo_de_mob_urbano_sinal (identificador);

/**
 * Criar dominio Unidades Administrativas
 */

CREATE TABLE distrito (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	data_publicacao date NOT NULL,
	codigo varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','distrito','geometria',3763,'MULTIPOLYGON',2);
ALTER TABLE distrito ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE municipio (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	data_publicacao date NOT NULL,
	codigo varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','municipio','geometria',3763,'MULTIPOLYGON',2);
ALTER TABLE municipio ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE freguesia (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	data_publicacao date NOT NULL,
	codigo varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','freguesia','geometria',3763,'MULTIPOLYGON',2);
ALTER TABLE freguesia ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE fronteira (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_estado_fronteira varchar(10) NOT NULL,
	data_publicacao date NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','fronteira','geometria',3763,'LINESTRING',2);
ALTER TABLE fronteira ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_estado_fronteira (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE fronteira ADD CONSTRAINT valor_estado_fronteira_id FOREIGN KEY (valor_estado_fronteira) REFERENCES valor_estado_fronteira (identificador);

/**
 * Criar dominio Infrastruturas e Serviços Públicos
 */

CREATE TABLE inst_gestao_ambiental (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255) NOT NULL,
	valor_instalacao_gestao_ambiental varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE inst_producao (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255) NOT NULL,
	descricao_da_funcao varchar(255),
	valor_instalacao_producao varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE conduta_de_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	diametro real,
	valor_conduta_agua varchar(10) NOT NULL,
	valor_posicao_vertical varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','conduta_de_agua','geometria',3763,'LINESTRING',2);
ALTER TABLE conduta_de_agua ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE elem_assoc_pgq (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_elemento_associado_pgq varchar(10) NOT NULL,
	nome varchar(255),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','elem_assoc_pgq','geometria',3763,'GEOMETRY',2);
ALTER TABLE elem_assoc_pgq ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE oleoduto_gasoduto_subtancias_quimicas (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	diametro real,
	valor_gasoduto_oleoduto_sub_quimicas varchar(10) NOT NULL,
	valor_posicao_vertical varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','oleoduto_gasoduto_subtancias_quimicas','geometria',3763,'LINESTRING',2);
ALTER TABLE oleoduto_gasoduto_subtancias_quimicas ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE elem_assoc_telecomunicacoes (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_elemento_associado_telecomunicacoes varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','elem_assoc_telecomunicacoes','geometria',3763,'POINT',2);
ALTER TABLE elem_assoc_telecomunicacoes ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE adm_publica (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255) NOT NULL,
	ponto_de_contacto varchar(255),
	valor_tipo_adm_publica varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);


CREATE TABLE equip_util_coletiva (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255) NOT NULL,
	ponto_de_contacto varchar(255),
	PRIMARY KEY (identificador)
);

CREATE TABLE lig_valor_tipo_equipamento_coletivo_equip_util_coletiva (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
  equip_util_coletiva_id uuid NOT NULL,
	valor_tipo_equipamento_coletivo_id varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

-- Ponto, Poligono
CREATE TABLE elem_assoc_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_elemento_associado_agua varchar(10) NOT NULL,
	nome varchar(255),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','elem_assoc_agua','geometria',3763,'GEOMETRY',2);
ALTER TABLE elem_assoc_agua ALTER COLUMN geometria SET NOT NULL;

-- Ponto, Poligono
CREATE TABLE elem_assoc_eletricidade (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_elemento_associado_electricidade varchar(10) NOT NULL,
	nome varchar(255),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','elem_assoc_eletricidade','geometria',3763,'GEOMETRY',2);
ALTER TABLE elem_assoc_eletricidade ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE cabo_electrico (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	tensao_nominal real,
	valor_designacao_tensao varchar(10) NOT NULL,
	valor_posicao_vertical varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','cabo_electrico','geometria',3763,'LINESTRING',2);
ALTER TABLE cabo_electrico ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE lig_adm_publica_edificio (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	adm_publica_id uuid NOT NULL,
	edificio_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE lig_equip_util_coletiva_edificio (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	equip_util_coletiva_id uuid NOT NULL,
	edificio_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_elemento_associado_pgq (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_elemento_associado_agua (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_instalacao_gestao_ambiental (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_elemento_associado_telecomunicacoes (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_adm_publica (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_equipamento_coletivo (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);
CREATE TABLE valor_conduta_agua (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_designacao_tensao (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_instalacao_producao (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_gasoduto_oleoduto_sub_quimicas (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_elemento_associado_electricidade (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_posicao_vertical (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE inst_gestao_ambiental ADD CONSTRAINT valor_instalacao_gestao_ambiental_id FOREIGN KEY (valor_instalacao_gestao_ambiental) REFERENCES valor_instalacao_gestao_ambiental (identificador);
ALTER TABLE inst_producao ADD CONSTRAINT valor_instalacao_producao_id FOREIGN KEY (valor_instalacao_producao) REFERENCES valor_instalacao_producao (identificador);
ALTER TABLE conduta_de_agua ADD CONSTRAINT valor_conduta_agua_id FOREIGN KEY (valor_conduta_agua) REFERENCES valor_conduta_agua (identificador);
ALTER TABLE conduta_de_agua ADD CONSTRAINT valor_posicao_vertical_id FOREIGN KEY (valor_posicao_vertical) REFERENCES valor_posicao_vertical (identificador);
ALTER TABLE elem_assoc_pgq ADD CONSTRAINT valor_elemento_associado_pgq_id FOREIGN KEY (valor_elemento_associado_pgq) REFERENCES valor_elemento_associado_pgq (identificador);
ALTER TABLE oleoduto_gasoduto_subtancias_quimicas ADD CONSTRAINT valor_gasoduto_oleoduto_sub_quimicas_id FOREIGN KEY (valor_gasoduto_oleoduto_sub_quimicas) REFERENCES valor_gasoduto_oleoduto_sub_quimicas (identificador);
ALTER TABLE oleoduto_gasoduto_subtancias_quimicas ADD CONSTRAINT valor_posicao_vertical_id FOREIGN KEY (valor_posicao_vertical) REFERENCES valor_posicao_vertical (identificador);
ALTER TABLE elem_assoc_telecomunicacoes ADD CONSTRAINT valor_elemento_associado_telecomunicacoes_id FOREIGN KEY (valor_elemento_associado_telecomunicacoes) REFERENCES valor_elemento_associado_telecomunicacoes (identificador);
ALTER TABLE adm_publica ADD CONSTRAINT valor_tipo_adm_publica_id FOREIGN KEY (valor_tipo_adm_publica) REFERENCES valor_tipo_adm_publica (identificador);
ALTER TABLE elem_assoc_agua ADD CONSTRAINT valor_elemento_associado_agua_id FOREIGN KEY (valor_elemento_associado_agua) REFERENCES valor_elemento_associado_agua (identificador);
ALTER TABLE elem_assoc_eletricidade ADD CONSTRAINT valor_elemento_associado_electricidade_id FOREIGN KEY (valor_elemento_associado_electricidade) REFERENCES valor_elemento_associado_electricidade (identificador);
ALTER TABLE cabo_electrico ADD CONSTRAINT valor_designacao_tensao_id FOREIGN KEY (valor_designacao_tensao) REFERENCES valor_designacao_tensao (identificador);
ALTER TABLE cabo_electrico ADD CONSTRAINT valor_posicao_vertical_id FOREIGN KEY (valor_posicao_vertical) REFERENCES valor_posicao_vertical (identificador);
ALTER TABLE lig_valor_tipo_equipamento_coletivo_equip_util_coletiva ADD CONSTRAINT lig_valor_tipo_equipamento_coletivo_equip_util_coletiva_1 FOREIGN KEY (equip_util_coletiva_id) REFERENCES equip_util_coletiva (identificador) ON DELETE CASCADE;
ALTER TABLE lig_valor_tipo_equipamento_coletivo_equip_util_coletiva ADD CONSTRAINT lig_valor_tipo_equipamento_coletivo_equip_util_coletiva_2 FOREIGN KEY (valor_tipo_equipamento_coletivo_id) REFERENCES valor_tipo_equipamento_coletivo (identificador);
ALTER TABLE lig_valor_tipo_equipamento_coletivo_equip_util_coletiva ADD CONSTRAINT equip_util_coletiva_id_valor_tipo_equipamento_coletivo_id_uk UNIQUE (equip_util_coletiva_id, valor_tipo_equipamento_coletivo_id);


/**
 * Criar dominio Construções
 */

CREATE TABLE sinal_geodesico (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	data_revisao date NOT NULL,
	nome varchar(255),
	valor_local_geodesico varchar(10) NOT NULL,
	valor_ordem varchar(10) NOT NULL,
	valor_tipo_sinal_geodesico varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','sinal_geodesico','geometria',3763,'POINT',3);
ALTER TABLE sinal_geodesico ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE constru_linear (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	suporte bool NOT NULL,
	valor_construcao_linear varchar(10) NOT NULL,
	largura real,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','constru_linear','geometria',3763,'LINESTRING',2);
ALTER TABLE constru_linear ALTER COLUMN geometria SET NOT NULL;

--Ponto, Poligono
CREATE TABLE constru_polig (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	valor_tipo_construcao varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','constru_polig','geometria',3763,'POLYGON',2);
ALTER TABLE constru_polig ALTER COLUMN geometria SET NOT NULL;

--Ponto, Poligono
CREATE TABLE ponto_interesse (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	valor_tipo_ponto_interesse varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','ponto_interesse','geometria',3763,'GEOMETRY',2);
ALTER TABLE ponto_interesse ALTER COLUMN geometria SET NOT NULL;

--Ponto, Poligono
CREATE TABLE edificio (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inst_producao_id uuid,
	inst_gestao_ambiental_id uuid,
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	altura_edificio real NOT NULL,
	data_const date,
	valor_condicao_const varchar(10),
	valor_elemento_edificio_xy varchar(10) NOT NULL,
	valor_elemento_edificio_z varchar(10) NOT NULL,
	valor_forma_edificio varchar(10),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','edificio','geometria',3763,'GEOMETRY',2);
ALTER TABLE edificio ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE nome_edificio (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
        edificio_id uuid NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE nome_edificio ADD CONSTRAINT nome_edificio_id_edificio_id FOREIGN KEY (edificio_id) REFERENCES edificio (identificador) ON DELETE CASCADE;

CREATE TABLE numero_policia_edificio (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
        edificio_id uuid NOT NULL,
	numero_policia varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE numero_policia_edificio ADD CONSTRAINT numero_policia_edificio_id_edificio_id FOREIGN KEY (edificio_id) REFERENCES edificio (identificador) ON DELETE CASCADE;

CREATE TABLE lig_valor_utilizacao_atual_edificio (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
        edificio_id uuid NOT NULL,
	valor_utilizacao_atual_id varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_condicao_const (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_sinal_geodesico (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_ponto_interesse (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_forma_edificio (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_construcao_linear (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_elemento_edificio_z (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_local_geodesico (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_utilizacao_atual (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_ordem (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_construcao (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_elemento_edificio_xy (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);


ALTER TABLE lig_valor_utilizacao_atual_edificio ADD CONSTRAINT lig_valor_utilizacao_atual_edificio_edificio FOREIGN KEY (edificio_id) REFERENCES edificio (identificador) ON DELETE CASCADE;
ALTER TABLE lig_valor_utilizacao_atual_edificio ADD CONSTRAINT lig_valor_utilizacao_atual_edificio_valor_utilizacao_atual FOREIGN KEY (valor_utilizacao_atual_id) REFERENCES valor_utilizacao_atual (identificador);
ALTER TABLE lig_valor_utilizacao_atual_edificio ADD CONSTRAINT edificio_id_valor_utilizacao_atual_id_uk UNIQUE (edificio_id, valor_utilizacao_atual_id);
ALTER TABLE sinal_geodesico ADD CONSTRAINT valor_local_geodesico_id FOREIGN KEY (valor_local_geodesico) REFERENCES valor_local_geodesico (identificador);
ALTER TABLE sinal_geodesico ADD CONSTRAINT valor_ordem_id FOREIGN KEY (valor_ordem) REFERENCES valor_ordem (identificador);
ALTER TABLE sinal_geodesico ADD CONSTRAINT valor_tipo_sinal_geodesico_id FOREIGN KEY (valor_tipo_sinal_geodesico) REFERENCES valor_tipo_sinal_geodesico (identificador);
ALTER TABLE constru_linear ADD CONSTRAINT valor_construcao_linear_id FOREIGN KEY (valor_construcao_linear) REFERENCES valor_construcao_linear (identificador);
ALTER TABLE constru_polig ADD CONSTRAINT valor_tipo_construcao_id FOREIGN KEY (valor_tipo_construcao) REFERENCES valor_tipo_construcao (identificador);
ALTER TABLE ponto_interesse ADD CONSTRAINT valor_tipo_ponto_interesse_id FOREIGN KEY (valor_tipo_ponto_interesse) REFERENCES valor_tipo_ponto_interesse (identificador);
ALTER TABLE edificio ADD CONSTRAINT valor_condicao_const_id FOREIGN KEY (valor_condicao_const) REFERENCES valor_condicao_const (identificador);
ALTER TABLE edificio ADD CONSTRAINT valor_elemento_edificio_xy_id FOREIGN KEY (valor_elemento_edificio_xy) REFERENCES valor_elemento_edificio_xy (identificador);
ALTER TABLE edificio ADD CONSTRAINT valor_elemento_edificio_z_id FOREIGN KEY (valor_elemento_edificio_z) REFERENCES valor_elemento_edificio_z (identificador);
ALTER TABLE edificio ADD CONSTRAINT valor_forma_edificio_id FOREIGN KEY (valor_forma_edificio) REFERENCES valor_forma_edificio (identificador);

/**
 * Criar dominio Transporte
 */

CREATE TABLE valor_posicao_vertical_transportes (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

/**
 * Criar dominio Transporte por Cabo
 */

CREATE TABLE area_infra_trans_cabo (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','area_infra_trans_cabo','geometria',3763,'POLYGON',2);
ALTER TABLE area_infra_trans_cabo ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE seg_via_cabo (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	valor_tipo_via_cabo varchar(10),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','seg_via_cabo','geometria',3763,'LINESTRING',2);
ALTER TABLE seg_via_cabo ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_tipo_via_cabo (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE seg_via_cabo ADD CONSTRAINT valor_tipo_via_cabo_id FOREIGN KEY (valor_tipo_via_cabo) REFERENCES valor_tipo_via_cabo (identificador);

/**
 * Criar dominio Transporte por Via Navegavel
 */

CREATE TABLE area_infra_trans_via_navegavel (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_tipo_area_infra_trans_via_navegavel varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','area_infra_trans_via_navegavel','geometria',3763,'POLYGON',2);
ALTER TABLE area_infra_trans_via_navegavel ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE infra_trans_via_navegavel (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255) NOT NULL,
	codigo_via_navegavel varchar(255),
	valor_tipo_infra_trans_via_navegavel varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','infra_trans_via_navegavel','geometria',3763,'POINT',2);
ALTER TABLE infra_trans_via_navegavel ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_tipo_area_infra_trans_via_navegavel (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_infra_trans_via_navegavel (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE area_infra_trans_via_navegavel ADD CONSTRAINT valor_tipo_area_infra_trans_via_navegavel_id FOREIGN KEY (valor_tipo_area_infra_trans_via_navegavel) REFERENCES valor_tipo_area_infra_trans_via_navegavel (identificador);
ALTER TABLE infra_trans_via_navegavel ADD CONSTRAINT valor_tipo_infra_trans_via_navegavel_id FOREIGN KEY (valor_tipo_infra_trans_via_navegavel) REFERENCES valor_tipo_infra_trans_via_navegavel (identificador);

/**
 * Criar dominio Transporte por Aereo
 */

CREATE TABLE area_infra_trans_aereo (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_tipo_area_infra_trans_aereo varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','area_infra_trans_aereo','geometria',3763,'POLYGON',2);
ALTER TABLE area_infra_trans_aereo ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE infra_trans_aereo (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	codigo_iata varchar(255),
	codigo_icao varchar(255),
	nome varchar(255),
	valor_categoria_infra_trans_aereo varchar(10) NOT NULL,
	valor_restricao_infra_trans_aereo varchar(10),
	valor_tipo_infra_trans_aereo varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','infra_trans_aereo','geometria',3763,'POINT',2);
ALTER TABLE infra_trans_aereo ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_tipo_area_infra_trans_aereo (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_restricao_infra_trans_aereo (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_categoria_infra_trans_aereo (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_infra_trans_aereo (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE area_infra_trans_aereo ADD CONSTRAINT valor_tipo_area_infra_trans_aereo_id FOREIGN KEY (valor_tipo_area_infra_trans_aereo) REFERENCES valor_tipo_area_infra_trans_aereo (identificador);
ALTER TABLE infra_trans_aereo ADD CONSTRAINT valor_categoria_infra_trans_aereo_id FOREIGN KEY (valor_categoria_infra_trans_aereo) REFERENCES valor_categoria_infra_trans_aereo (identificador);
ALTER TABLE infra_trans_aereo ADD CONSTRAINT valor_restricao_infra_trans_aereo_id FOREIGN KEY (valor_restricao_infra_trans_aereo) REFERENCES valor_restricao_infra_trans_aereo (identificador);
ALTER TABLE infra_trans_aereo ADD CONSTRAINT valor_tipo_infra_trans_aereo_id FOREIGN KEY (valor_tipo_infra_trans_aereo) REFERENCES valor_tipo_infra_trans_aereo (identificador);

/**
 * Criar dominio Transporte Ferroviario
 */

CREATE TABLE seg_via_ferrea (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	eletrific bool NOT NULL,
	gestao varchar(255),
	velocidade_max int4,
	valor_categoria_bitola varchar(10) NOT NULL,
	valor_estado_linha_ferrea varchar(10) NOT NULL,
	valor_posicao_vertical_transportes varchar(10) NOT NULL,
	valor_tipo_linha_ferrea varchar(10) NOT NULL,
	valor_tipo_troco_via_ferrea varchar(10) NOT NULL,
	valor_via_ferrea varchar(10),
	jurisdicao varchar(255),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','seg_via_ferrea','geometria',3763,'LINESTRING',3);
ALTER TABLE seg_via_ferrea ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE linha_ferrea (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	codigo_linha_ferrea varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE area_infra_trans_ferrov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	infra_trans_ferrov_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','area_infra_trans_ferrov','geometria',3763,'POLYGON',2);
ALTER TABLE area_infra_trans_ferrov ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE infra_trans_ferrov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	codigo_infra_ferrov varchar(255),
	nome varchar(255),
	nplataformas int4,
	valor_tipo_uso_infra_trans_ferrov varchar(10),
	valor_tipo_infra_trans_ferrov varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','infra_trans_ferrov','geometria',3763,'POINT',2);
ALTER TABLE infra_trans_ferrov ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE no_trans_ferrov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_tipo_no_trans_ferrov varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','no_trans_ferrov','geometria',3763,'POINT',3);
ALTER TABLE no_trans_ferrov ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE lig_infratransferrov_notransferrov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	infra_trans_ferrov_id uuid NOT NULL,
	no_trans_ferrov_id uuid NOT NULL,
	PRIMARY KEY (identificador)

);

CREATE TABLE lig_segviaferrea_linhaferrea (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	seg_via_ferrea_id uuid NOT NULL,
	linha_ferrea_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_categoria_bitola (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_uso_infra_trans_ferrov (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_linha_ferrea (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_troco_via_ferrea (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_estado_linha_ferrea (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);


CREATE TABLE valor_via_ferrea (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_infra_trans_ferrov (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_no_trans_ferrov (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE seg_via_ferrea ADD CONSTRAINT valor_categoria_bitola_id FOREIGN KEY (valor_categoria_bitola) REFERENCES valor_categoria_bitola (identificador);
ALTER TABLE seg_via_ferrea ADD CONSTRAINT valor_estado_linha_ferrea_id FOREIGN KEY (valor_estado_linha_ferrea) REFERENCES valor_estado_linha_ferrea (identificador);
ALTER TABLE seg_via_ferrea ADD CONSTRAINT valor_posicao_vertical_transportes_id FOREIGN KEY (valor_posicao_vertical_transportes) REFERENCES valor_posicao_vertical_transportes (identificador);
ALTER TABLE seg_via_ferrea ADD CONSTRAINT valor_tipo_linha_ferrea_id FOREIGN KEY (valor_tipo_linha_ferrea) REFERENCES valor_tipo_linha_ferrea (identificador);
ALTER TABLE seg_via_ferrea ADD CONSTRAINT valor_tipo_troco_via_ferrea_id FOREIGN KEY (valor_tipo_troco_via_ferrea) REFERENCES valor_tipo_troco_via_ferrea (identificador);
ALTER TABLE seg_via_ferrea ADD CONSTRAINT valor_via_ferrea_id FOREIGN KEY (valor_via_ferrea) REFERENCES valor_via_ferrea (identificador);
ALTER TABLE infra_trans_ferrov ADD CONSTRAINT valor_tipo_uso_infra_trans_ferrov_id FOREIGN KEY (valor_tipo_uso_infra_trans_ferrov) REFERENCES valor_tipo_uso_infra_trans_ferrov (identificador);
ALTER TABLE infra_trans_ferrov ADD CONSTRAINT valor_tipo_infra_trans_ferrov_id FOREIGN KEY (valor_tipo_infra_trans_ferrov) REFERENCES valor_tipo_infra_trans_ferrov (identificador);
ALTER TABLE no_trans_ferrov ADD CONSTRAINT valor_tipo_no_trans_ferrov_id FOREIGN KEY (valor_tipo_no_trans_ferrov) REFERENCES valor_tipo_no_trans_ferrov (identificador);
ALTER TABLE lig_infratransferrov_notransferrov ADD CONSTRAINT infra_trans_ferrov_id_no_trans_ferrov_id_uk UNIQUE (infra_trans_ferrov_id, no_trans_ferrov_id)
ALTER TABLE lig_infratransferrov_notransferrov ADD CONSTRAINT lig_infratransferrov_notransferrov_1 FOREIGN KEY (no_trans_ferrov_id) REFERENCES no_trans_ferrov (identificador) ON DELETE CASCADE;
ALTER TABLE lig_infratransferrov_notransferrov ADD CONSTRAINT lig_infratransferrov_notransferrov_2 FOREIGN KEY (infra_trans_ferrov_id) REFERENCES infra_trans_ferrov (identificador) ON DELETE CASCADE;
/**
 * Criar dominio Transporte Rodoviario
 */

CREATE TABLE seg_via_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	gestao varchar(255),
	largura_via_rodov real,
	multipla_faixa_rodagem bool,
	num_vias_transito int4 NOT NULL,
	pavimentado bool NOT NULL,
	velocidade_max int4,
	jurisdicao varchar(255),
	valor_caract_fisica_rodov varchar(10) NOT NULL,
	valor_estado_via_rodov varchar(10) NOT NULL,
	valor_posicao_vertical_transportes varchar(10) NOT NULL,
	valor_restricao_acesso varchar(10),
	valor_sentido varchar(10) NOT NULL,
	valor_tipo_troco_rodoviario varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','seg_via_rodov','geometria',3763,'LINESTRING',3);
ALTER TABLE seg_via_rodov ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE lig_valor_tipo_circulacao_seg_via_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	seg_via_rodov_id uuid NOT NULL,
	valor_tipo_circulacao_id varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE area_infra_trans_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	infra_trans_rodov_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','area_infra_trans_rodov','geometria',3763,'POLYGON',2);
ALTER TABLE area_infra_trans_rodov ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE infra_trans_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	valor_tipo_infra_trans_rodov varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','infra_trans_rodov','geometria',3763,'POINT',2);
ALTER TABLE infra_trans_rodov ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE lig_valor_tipo_servico_infra_trans_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	infra_trans_rodov_id uuid NOT NULL,
	valor_tipo_servico_id varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE no_trans_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_tipo_no_trans_rodov varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','no_trans_rodov','geometria',3763,'POINT',3);
ALTER TABLE no_trans_rodov ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE lig_infratransrodov_notransrodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	infra_trans_rodov_id uuid NOT NULL,
	no_trans_rodov_id uuid NOT NULL,
	PRIMARY KEY (identificador)

);

CREATE TABLE via_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	codigo_via_rodov varchar(255) NOT NULL,
	data_cat date NOT NULL,
	fonte_aquisicao_dados varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	nome_alternativo varchar(255),
	tipo_via_rodov_abv varchar(255) NOT NULL,
	tipo_via_rodov_c varchar(255) NOT NULL,
	tipo_via_rodov_d varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE via_rodov_limite (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	valor_tipo_limite varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','via_rodov_limite','geometria',3763,'LINESTRING',3);
ALTER TABLE via_rodov_limite ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE obra_arte (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	valor_tipo_obra_arte varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','obra_arte','geometria',3763,'POLYGON',3);
ALTER TABLE obra_arte ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE lig_segviarodov_viarodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	seg_via_rodov_id uuid NOT NULL,
	via_rodov_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE lig_segviarodov_viarodovlimite (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	seg_via_rodov_id uuid NOT NULL,
	via_rodov_limite_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_sentido (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_servico (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_estado_via_rodov (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_caract_fisica_rodov (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_obra_arte (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_limite (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_infra_trans_rodov (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_troco_rodoviario (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_restricao_acesso (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_circulacao (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_no_trans_rodov (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE lig_valor_tipo_servico_infra_trans_rodov ADD CONSTRAINT valor_tipo_servico_infra_trans_rodov_infra_trans_rodov FOREIGN KEY (infra_trans_rodov_id) REFERENCES infra_trans_rodov (identificador) ON DELETE CASCADE;
ALTER TABLE lig_valor_tipo_servico_infra_trans_rodov ADD CONSTRAINT valor_tipo_servico_infra_trans_rodov_valor_tipo_servico FOREIGN KEY (valor_tipo_servico_id) REFERENCES valor_tipo_servico (identificador);
ALTER TABLE lig_valor_tipo_servico_infra_trans_rodov ADD CONSTRAINT infra_trans_rodov_id_valor_tipo_servico_id_uk UNIQUE (infra_trans_rodov_id, valor_tipo_servico_id);
ALTER TABLE lig_valor_tipo_circulacao_seg_via_rodov ADD CONSTRAINT valor_tipo_circulacao_seg_via_rodov_seg_via_rodov FOREIGN KEY (seg_via_rodov_id) REFERENCES seg_via_rodov (identificador) ON DELETE CASCADE;
ALTER TABLE lig_valor_tipo_circulacao_seg_via_rodov ADD CONSTRAINT valor_tipo_circulacao_seg_via_rodov_valor_tipo_circulacao FOREIGN KEY (valor_tipo_circulacao_id) REFERENCES valor_tipo_circulacao (identificador);
ALTER TABLE lig_valor_tipo_circulacao_seg_via_rodov ADD CONSTRAINT seg_via_rodov_id_valor_tipo_circulacao_id_uk UNIQUE (seg_via_rodov_id, valor_tipo_circulacao_id);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_caract_fisica_rodov_id FOREIGN KEY (valor_caract_fisica_rodov) REFERENCES valor_caract_fisica_rodov (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_estado_via_rodov_id FOREIGN KEY (valor_estado_via_rodov) REFERENCES valor_estado_via_rodov (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_posicao_vertical_transportes_id FOREIGN KEY (valor_posicao_vertical_transportes) REFERENCES valor_posicao_vertical_transportes (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_restricao_acesso_id FOREIGN KEY (valor_restricao_acesso) REFERENCES valor_restricao_acesso (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_sentido_id FOREIGN KEY (valor_sentido) REFERENCES valor_sentido (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_tipo_troco_rodoviario_id FOREIGN KEY (valor_tipo_troco_rodoviario) REFERENCES valor_tipo_troco_rodoviario (identificador);
ALTER TABLE infra_trans_rodov ADD CONSTRAINT valor_tipo_infra_trans_rodov_id FOREIGN KEY (valor_tipo_infra_trans_rodov) REFERENCES valor_tipo_infra_trans_rodov (identificador);
ALTER TABLE no_trans_rodov ADD CONSTRAINT valor_tipo_no_trans_rodov_id FOREIGN KEY (valor_tipo_no_trans_rodov) REFERENCES valor_tipo_no_trans_rodov (identificador);
ALTER TABLE via_rodov_limite ADD CONSTRAINT valor_tipo_limite_id FOREIGN KEY (valor_tipo_limite) REFERENCES valor_tipo_limite (identificador);
ALTER TABLE obra_arte ADD CONSTRAINT valor_tipo_obra_arte_id FOREIGN KEY (valor_tipo_obra_arte) REFERENCES valor_tipo_obra_arte (identificador);

/**
 * Criar dominio Hidrografia
 */

CREATE TABLE nascente (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	id_hidrografico varchar(255),
	valor_persistencia_hidrologica varchar(10),
	valor_tipo_nascente varchar(10),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','nascente','geometria',3763,'POINT',3);
ALTER TABLE nascente ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE agua_lentica (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	cota_plena_armazenamento bool NOT NULL,
	data_fonte_dados DATE,
	mare bool NOT NULL,
	origem_natural bool,
	profundidade_media real,
	id_hidrografico varchar(255),
	valor_agua_lentica varchar(10) NOT NULL,
	valor_persistencia_hidrologica varchar(10),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','agua_lentica','geometria',3763,'POLYGON',3);
ALTER TABLE agua_lentica ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE terreno_marginal (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	id_hidrografico varchar(255),
	valor_tipo_terreno_marginal varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','terreno_marginal','geometria',3763,'POLYGON',2);
ALTER TABLE terreno_marginal ALTER COLUMN geometria SET NOT NULL;

-- Linha
CREATE TABLE curso_de_agua_eixo (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	comprimento real,
	delimitacao_conhecida bool NOT NULL,
	ficticio bool NOT NULL,
	mare bool,
	navegavel_ou_flutuavel bool NOT NULL,
	largura real,
	id_hidrografico varchar(255),
	id_curso_de_agua_area uuid,
	id_agua_lentica uuid,
	ordem_hidrologica varchar(255),
	origem_natural bool,
	valor_curso_de_agua varchar(10) NOT NULL,
	valor_persistencia_hidrologica varchar(10),
	valor_posicao_vertical varchar(10) NOT NULL,
	valor_estado_instalacao varchar(10),
	valor_ficticio varchar(10),
	valor_natureza varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','curso_de_agua_eixo','geometria',3763,'LINESTRING',3);
ALTER TABLE curso_de_agua_eixo ALTER COLUMN geometria SET NOT NULL;

-- Poligono
CREATE TABLE curso_de_agua_area (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	delimitacao_conhecida bool NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','curso_de_agua_area','geometria',3763,'POLYGON',3);
ALTER TABLE curso_de_agua_area ALTER COLUMN geometria SET NOT NULL;

-- Ponto, Poligono
CREATE TABLE queda_de_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	altura real,
	id_hidrografico varchar(255),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','queda_de_agua','geometria',3763,'POINT',3);
ALTER TABLE queda_de_agua ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE zona_humida (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	mare bool NOT NULL,
	id_hidrografico varchar(255),
	valor_zona_humida varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','zona_humida','geometria',3763,'POLYGON',3);
ALTER TABLE zona_humida ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE no_hidrografico (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	id_hidrografico varchar(255),
	valor_tipo_no_hidrografico varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','no_hidrografico','geometria',3763,'POINT',3);
ALTER TABLE no_hidrografico ALTER COLUMN geometria SET NOT NULL;

-- Linha, Poligono
CREATE TABLE barreira (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	id_hidrografico varchar(255),
	valor_barreira varchar(10) NOT NULL,
	valor_estado_instalacao varchar(10),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','barreira','geometria',3763,'GEOMETRY',2);
ALTER TABLE barreira ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_barreira (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

-- Poligono
CREATE TABLE constru_na_margem (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	nome varchar(255),
	valor_tipo_const_margem varchar(10) NOT NULL,
	valor_estado_instalacao varchar(10),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','constru_na_margem','geometria',3763,'POLYGON',2);
ALTER TABLE constru_na_margem ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_tipo_const_margem (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE fronteira_terra_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	data_fonte_dados date NOT NULL,
	fonte_dados varchar(255) NOT NULL,
	ilha bool NOT NULL,
	origem_natural bool,
	valor_tipo_fronteira_terra_agua varchar(10),
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','fronteira_terra_agua','geometria',3763,'LINESTRING',3);
ALTER TABLE fronteira_terra_agua ALTER COLUMN geometria SET NOT NULL;



CREATE TABLE valor_tipo_terreno_marginal (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_ficticio (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_natureza (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_fronteira_terra_agua (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_persistencia_hidrologica (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_nascente (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_no_hidrografico (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_agua_lentica (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_curso_de_agua (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_zona_humida (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_estado_instalacao (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE nascente ADD CONSTRAINT valor_persistencia_hidrologica_id FOREIGN KEY (valor_persistencia_hidrologica) REFERENCES valor_persistencia_hidrologica (identificador);
ALTER TABLE nascente ADD CONSTRAINT valor_tipo_nascente_id FOREIGN KEY (valor_tipo_nascente) REFERENCES valor_tipo_nascente (identificador);
ALTER TABLE agua_lentica ADD CONSTRAINT valor_agua_lentica_id FOREIGN KEY (valor_agua_lentica) REFERENCES valor_agua_lentica (identificador);
ALTER TABLE agua_lentica ADD CONSTRAINT valor_persistencia_hidrologica_id FOREIGN KEY (valor_persistencia_hidrologica) REFERENCES valor_persistencia_hidrologica (identificador);
ALTER TABLE terreno_marginal ADD CONSTRAINT valor_tipo_terreno_marginal_id FOREIGN KEY (valor_tipo_terreno_marginal) REFERENCES valor_tipo_terreno_marginal (identificador);
ALTER TABLE curso_de_agua_eixo ADD CONSTRAINT valor_curso_de_agua_id FOREIGN KEY (valor_curso_de_agua) REFERENCES valor_curso_de_agua (identificador);
ALTER TABLE curso_de_agua_eixo ADD CONSTRAINT valor_persistencia_hidrologica_id FOREIGN KEY (valor_persistencia_hidrologica) REFERENCES valor_persistencia_hidrologica (identificador);
ALTER TABLE curso_de_agua_eixo ADD CONSTRAINT valor_posicao_vertical_id FOREIGN KEY (valor_posicao_vertical) REFERENCES valor_posicao_vertical (identificador);
ALTER TABLE curso_de_agua_eixo ADD CONSTRAINT valor_estado_instalacao_id FOREIGN KEY (valor_estado_instalacao) REFERENCES valor_estado_instalacao (identificador);
ALTER TABLE curso_de_agua_eixo ADD CONSTRAINT valor_ficticio_id FOREIGN KEY (valor_ficticio) REFERENCES valor_ficticio (identificador);
ALTER TABLE curso_de_agua_eixo ADD CONSTRAINT valor_natureza_id FOREIGN KEY (valor_natureza) REFERENCES valor_natureza (identificador);
ALTER TABLE zona_humida ADD CONSTRAINT valor_zona_humida_id FOREIGN KEY (valor_zona_humida) REFERENCES valor_zona_humida (identificador);
ALTER TABLE no_hidrografico ADD CONSTRAINT valor_tipo_no_hidrografico_id FOREIGN KEY (valor_tipo_no_hidrografico) REFERENCES valor_tipo_no_hidrografico (identificador);
ALTER TABLE barreira ADD CONSTRAINT valor_barreira_id FOREIGN KEY (valor_barreira) REFERENCES valor_barreira (identificador);
ALTER TABLE barreira ADD CONSTRAINT valor_estado_instalacao_id_2 FOREIGN KEY (valor_estado_instalacao) REFERENCES valor_estado_instalacao (identificador);
ALTER TABLE constru_na_margem ADD CONSTRAINT valor_tipo_const_margem_id FOREIGN KEY (valor_tipo_const_margem) REFERENCES valor_tipo_const_margem (identificador);
ALTER TABLE constru_na_margem ADD CONSTRAINT valor_estado_instalacao_id_3 FOREIGN KEY (valor_estado_instalacao) REFERENCES valor_estado_instalacao (identificador);
ALTER TABLE fronteira_terra_agua ADD CONSTRAINT valor_tipo_fronteira_terra_agua_id FOREIGN KEY (valor_tipo_fronteira_terra_agua) REFERENCES valor_tipo_fronteira_terra_agua (identificador);

/**
 * Criar tabela area_trabalho auxiliar
 */

CREATE TABLE area_trabalho (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto timestamp without time zone NOT NULL,
	fim_objeto timestamp without time zone,
	data date NOT NULL,
	data_homologacao date,
	nome varchar(255) NOT NULL,
	nome_proprietario varchar(255) NOT NULL,
	nome_produtor varchar(255) NOT NULL,
	valor_nivel_de_detalhe varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

SELECT AddGeometryColumn ('public','area_trabalho','geometria',3763,'POLYGON',2);
ALTER TABLE area_trabalho ALTER COLUMN geometria SET NOT NULL;

CREATE TABLE valor_nivel_de_detalhe (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

/**
 * Criar relacoes entre tabelas
 */
 ALTER TABLE area_trabalho ADD CONSTRAINT valor_nivel_de_detalhe_id FOREIGN KEY (valor_nivel_de_detalhe) REFERENCES valor_nivel_de_detalhe (identificador);

/**
 * Dominio Ocupacao de Solos
 */

ALTER TABLE areas_artificializadas ADD CONSTRAINT localizacao_instalacao_ambiental FOREIGN KEY (inst_gestao_ambiental_id) REFERENCES inst_gestao_ambiental (identificador);
ALTER TABLE areas_artificializadas ADD CONSTRAINT localizacao_instalacao_producao FOREIGN KEY (inst_producao_id) REFERENCES inst_producao (identificador);
ALTER TABLE areas_artificializadas ADD CONSTRAINT localizacao_equip_util_coletiva FOREIGN KEY (equip_util_coletiva_id) REFERENCES equip_util_coletiva (identificador);

/**
 * Dominio Construcoes
 */

ALTER TABLE edificio ADD CONSTRAINT localizacao_instalacao_ambiental FOREIGN KEY (inst_gestao_ambiental_id) REFERENCES inst_gestao_ambiental (identificador);
ALTER TABLE edificio ADD CONSTRAINT localizacao_instalacao_producao FOREIGN KEY (inst_producao_id) REFERENCES inst_producao (identificador);

/**
 * Dominio Infraestruturas e Servicos Publicos
 */

ALTER TABLE lig_adm_publica_edificio ADD CONSTRAINT localizacao_servico_publico_1 FOREIGN KEY (edificio_id) REFERENCES edificio (identificador) ON DELETE CASCADE;
ALTER TABLE lig_adm_publica_edificio ADD CONSTRAINT localizacao_servico_publico_2 FOREIGN KEY (adm_publica_id) REFERENCES adm_publica (identificador) ON DELETE CASCADE;
ALTER TABLE lig_adm_publica_edificio ADD CONSTRAINT adm_publica_id_edificio_id_uk UNIQUE (adm_publica_id, edificio_id)
ALTER TABLE lig_equip_util_coletiva_edificio ADD CONSTRAINT localizacao_equip_util_coletiva_1 FOREIGN KEY (edificio_id) REFERENCES edificio (identificador) ON DELETE CASCADE;
ALTER TABLE lig_equip_util_coletiva_edificio ADD CONSTRAINT localizacao_equip_util_coletiva_2 FOREIGN KEY (equip_util_coletiva_id) REFERENCES equip_util_coletiva (identificador) ON DELETE CASCADE;
ALTER TABLE lig_equip_util_coletiva_edificio ADD CONSTRAINT equip_util_coletiva_id_edificio_id_uk UNIQUE (equip_util_coletiva_id, edificio_id)


/**
 * Dominio Transporte Ferroviario
 */

ALTER TABLE area_infra_trans_ferrov ADD CONSTRAINT area_infra_trans_ferrov FOREIGN KEY (infra_trans_ferrov_id) REFERENCES infra_trans_ferrov (identificador);
ALTER TABLE lig_segviaferrea_linhaferrea ADD CONSTRAINT lig_segviaferrea_linhaferrea_1 FOREIGN KEY (seg_via_ferrea_id) REFERENCES seg_via_ferrea (identificador) ON DELETE CASCADE;
ALTER TABLE lig_segviaferrea_linhaferrea ADD CONSTRAINT lig_segviaferrea_linhaferrea_2 FOREIGN KEY (linha_ferrea_id) REFERENCES linha_ferrea (identificador) ON DELETE CASCADE;
ALTER TABLE lig_segviaferrea_linhaferrea ADD CONSTRAINT seg_via_ferrea_id_linha_ferrea_id_uk UNIQUE (seg_via_ferrea_id, linha_ferrea_id)

/**
 * Dominio Transporte Rodoviario
 */

ALTER TABLE area_infra_trans_rodov ADD CONSTRAINT area_infra_trans_rodov FOREIGN KEY (infra_trans_rodov_id) REFERENCES infra_trans_rodov (identificador);
ALTER TABLE lig_segviarodov_viarodov ADD CONSTRAINT lig_segviarodov_viarodov_1 FOREIGN KEY (seg_via_rodov_id) REFERENCES seg_via_rodov (identificador) ON DELETE CASCADE;;
ALTER TABLE lig_segviarodov_viarodov ADD CONSTRAINT lig_segviarodov_viarodov_2 FOREIGN KEY (via_rodov_id) REFERENCES via_rodov (identificador) ON DELETE CASCADE;;
ALTER TABLE lig_segviarodov_viarodov ADD CONSTRAINT seg_via_rodov_id_via_rodov_id_uk UNIQUE (seg_via_rodov_id, via_rodov_id);

ALTER TABLE lig_segviarodov_viarodovlimite ADD CONSTRAINT lig_segviarodov_viarodovlimite_1 FOREIGN KEY (via_rodov_limite_id) REFERENCES via_rodov_limite (identificador) ON DELETE CASCADE;
ALTER TABLE lig_segviarodov_viarodovlimite ADD CONSTRAINT lig_segviarodov_viarodovlimite_2 FOREIGN KEY (seg_via_rodov_id) REFERENCES seg_via_rodov (identificador) ON DELETE CASCADE;
ALTER TABLE lig_segviarodov_viarodovlimite ADD CONSTRAINT seg_via_rodov_id_via_rodov_limite_id_uk UNIQUE (seg_via_rodov_id, via_rodov_limite_id);

ALTER TABLE lig_infratransrodov_notransrodov ADD CONSTRAINT lig_infratransrodov_notransrodov_1 FOREIGN KEY (NO_trans_rodov_id) REFERENCES no_trans_rodov (identificador) ON DELETE CASCADE;
ALTER TABLE lig_infratransrodov_notransrodov ADD CONSTRAINT lig_infratransrodov_notransrodov_2 FOREIGN KEY (infra_trans_rodov_id) REFERENCES infra_trans_rodov (identificador) ON DELETE CASCADE;
ALTER TABLE lig_infratransrodov_notransrodov ADD CONSTRAINT infra_trans_rodov_id_no_trans_rodov_id_uk UNIQUE (infra_trans_rodov_id, no_trans_rodov_id)

/**
 * Cria trigger para validacao de geometria ponto ou poligono
 */
CREATE OR REPLACE FUNCTION trigger_point_polygon_validation() RETURNS trigger AS $BODY$
BEGIN
if(st_geometrytype(NEW.geometria) like 'ST_Point' OR st_geometrytype(NEW.geometria) like 'ST_Polygon') then
	RETURN NEW;
end if;
RAISE EXCEPTION 'Invalid geometry type only point or polygon are accepted!';
END;
$BODY$ LANGUAGE plpgsql VOLATILE;

/**
 * Cria trigger para validacao de geometria linha ou poligono
 */
CREATE OR REPLACE FUNCTION trigger_linestring_polygon_validation() RETURNS trigger AS $BODY$
BEGIN
if(st_geometrytype(NEW.geometria) like 'ST_LineString' OR st_geometrytype(NEW.geometria) like 'ST_Polygon') then
	RETURN NEW;
end if;
RAISE EXCEPTION 'Invalid geometry type only linestring or polygon are accepted!';
END;
$BODY$ LANGUAGE plpgsql VOLATILE;

/**
 * Cria trigger dominio Mobiliário Urbano
 */

CREATE TRIGGER mob_urbano_sinal_geometry_check
BEFORE INSERT ON "mob_urbano_sinal"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

/**
 * Cria trigger dominio Infraestruturas e Servicos Publicos
 */

CREATE TRIGGER elem_assoc_agua_geometry_check
BEFORE INSERT ON "elem_assoc_agua"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

CREATE TRIGGER elem_assoc_eletricidade_geometry_check
BEFORE INSERT ON "elem_assoc_eletricidade"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

CREATE TRIGGER elem_assoc_pgq_geometry_check
BEFORE INSERT ON "elem_assoc_pgq"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

/**
 * Cria trigger dominio Construcoes
 */

CREATE TRIGGER edifico_geometry_check
BEFORE INSERT ON "edificio"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

CREATE TRIGGER ponto_interesse_geometry_check
BEFORE INSERT ON "ponto_interesse"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

/**
 * Cria trigger dominio Hidrografia
 */

CREATE TRIGGER queda_de_agua_geometry_check
BEFORE INSERT ON "queda_de_agua"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

CREATE TRIGGER barreira_geometry_check
BEFORE INSERT ON "barreira"
FOR EACH ROW EXECUTE PROCEDURE trigger_linestring_polygon_validation();
