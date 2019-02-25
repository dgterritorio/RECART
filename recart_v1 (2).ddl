/**
 * Para executar o script executar `psql -U postgres postgres -f recart.ddl`
 */

/**
 * Criar base de dados
 */

CREATE DATABASE recart WITH ENCODING 'UTF8' LC_COLLATE='pt_PT.UTF-8' LC_CTYPE='pt_PT.UTF-8' TEMPLATE='template0';

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
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POINT, 3763) NOT NULL,
	valor_local_nomeado varchar(10) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

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
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	valor_areas_agricolas_florestais_matos varchar(10) NOT NULL,
	nome varchar(255),
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE areas_artificializadas (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inst_producao_id uuid NOT NULL,
	inst_gestao_ambiental_id uuid NOT NULL,
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	valor_areas_artificializadas varchar(10) NOT NULL,
	nome varchar(255),
	PRIMARY KEY (identificador)
);

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
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	valor_classifica varchar(10) NOT NULL,
	valor_natureza_linha varchar(10) NOT NULL,
	artificial bool NOT NULL,
	desce_direita bool NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE ponto_cotado (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	geometria geometry(POINT, 3763) NOT NULL,
	valor_classifica_las varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE curva_de_nivel (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	geometria geometry(LINESTRING, 3763) NOT NULL,
	valor_tipo_curva varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

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
 * Criar dominio Equipamento Urbano
 */

-- Ponto, Poligono
CREATE TABLE equipamento_urbano (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763) NOT NULL, 
	valor_tipo_de_equipamento_urbano varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_de_equipamento_urbano (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE equipamento_urbano ADD CONSTRAINT valor_tipo_de_equipamento_urbano_id FOREIGN KEY (valor_tipo_de_equipamento_urbano) REFERENCES valor_tipo_de_equipamento_urbano (identificador);

/**
 * Criar dominio Unidades Administrativas
 */

CREATE TABLE distrito (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	dicofre varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE concelho (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	dico varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE freguesia (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	dicofre varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE fronteira (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	valor_estado_fronteira varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

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
	inicio_objeto date NOT NULL,
	fim_objeto time,
	valor_instalacao_gestao_ambiental varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE inst_producao (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	descricao_da_funcao varchar(255) NOT NULL,
	valor_instalacao_producao varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE conduta_de_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	diametro int4 NOT NULL,
	valor_conduta_agua varchar(10) NOT NULL,
	valor_posicao_vertical varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

-- Ponto, Poligono
CREATE TABLE elem_assoc_pgq (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763)NOT NULL, 
	valor_elemento_associado_pgq varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE oleoduto_gasoduto_subtancias_quimicas (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	diametro int4 NOT NULL,
	valor_gasoduto_oleoduto_sub_quimicas varchar(10) NOT NULL,
	valor_posicao_vertical varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE elem_assoc_telecomunicacoes (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POINT, 3763) NOT NULL,
	valor_elemento_associado_telecomunicacoes varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE servico_publico (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	ponto_de_contacto varchar(255) NOT NULL,
	valor_tipo_servico_publico varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

-- Ponto, Poligono
CREATE TABLE elem_assoc_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763)NOT NULL,
	valor_elemento_associado_agua varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

-- Ponto, Poligono
CREATE TABLE elem_assoc_eletricidade (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763)NOT NULL, 
	valor_elemento_associado_electricidade varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE cabo_electrico (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	voltagem_nominal int4 NOT NULL,
	valor_designacao_tensao varchar(10) NOT NULL,
	valor_posicao_vertical varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE lig_servicopublico_edificio (
	servico_publico_id uuid NOT NULL,
	edificio_id uuid NOT NULL,
	PRIMARY KEY (servico_publico_id, edificio_id)
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

CREATE TABLE valor_tipo_servico_publico (
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
ALTER TABLE servico_publico ADD CONSTRAINT valor_tipo_servico_publico_id FOREIGN KEY (valor_tipo_servico_publico) REFERENCES valor_tipo_servico_publico (identificador);
ALTER TABLE elem_assoc_agua ADD CONSTRAINT valor_elemento_associado_agua_id FOREIGN KEY (valor_elemento_associado_agua) REFERENCES valor_elemento_associado_agua (identificador);
ALTER TABLE elem_assoc_eletricidade ADD CONSTRAINT valor_elemento_associado_electricidade_id FOREIGN KEY (valor_elemento_associado_electricidade) REFERENCES valor_elemento_associado_electricidade (identificador);
ALTER TABLE cabo_electrico ADD CONSTRAINT valor_designacao_tensao_id FOREIGN KEY (valor_designacao_tensao) REFERENCES valor_designacao_tensao (identificador);
ALTER TABLE cabo_electrico ADD CONSTRAINT valor_posicao_vertical_id FOREIGN KEY (valor_posicao_vertical) REFERENCES valor_posicao_vertical (identificador);

/**
 * Criar dominio Construções
 */

CREATE TABLE sinal_geodesico (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POINT, 3763) NOT NULL,
	cota_sinal int4 NOT NULL,
	nome varchar(255) NOT NULL,
	valor_local_geodesico varchar(10) NOT NULL,
	valor_ordem varchar(10) NOT NULL,
	valor_tipo_sinal_geodesico varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE constru_linear (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	nome varchar(255),
	suporte bool NOT NULL,
	valor_construcao_linear varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

--Ponto, Poligono
CREATE TABLE constru_polig (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inst_producao_id uuid NOT NULL,
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763) NOT NULL,
	nome varchar(255),
	valor_tipo_construcao varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

--Ponto, Poligono
CREATE TABLE ponto_interesse (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763) NOT NULL,
	nome varchar(255) NOT NULL,
	valor_tipo_ponto_interesse varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

--Ponto, Poligono
CREATE TABLE edificio (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inst_producao_id uuid,
	inst_gestao_ambiental_id uuid,
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763)NOT NULL,
	altura_edificio int4 NOT NULL,
	altura_medida bool NOT NULL,
	data_const date NOT NULL,
	exaposxy int4 NOT NULL,
	exaposz int4 NOT NULL,
	nome varchar(255),
	numero_policia varchar(255),
	valor_condicao_const varchar(10) NOT NULL,
	valor_elemento_edificio_xy varchar(10) NOT NULL,
	valor_elemento_edificio_z varchar(10) NOT NULL,
	valor_forma_edificio varchar(10),
	valor_utilizacao_atual varchar(10) NOT NULL,
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

CREATE TABLE valor_metodo_aquis (
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
ALTER TABLE edificio ADD CONSTRAINT valor_utilizacao_atual_id FOREIGN KEY (valor_utilizacao_atual) REFERENCES valor_utilizacao_atual (identificador);

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
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE seg_via_cabo (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto date NOT NULL,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	nome varchar(255) NOT NULL,
	valor_tipo_via_cabo varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

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
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	valor_tipo_area_infra_trans_via_navegavel varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE infra_trans_via_navegavel (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POINT, 3763) NOT NULL,
	nome varchar(255) NOT NULL,
	codigo_icao varchar(255) NOT NULL,
	codigo_via_navegavel varchar(255) NOT NULL,
	valor_tipo_infra_trans_via_navegavel varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

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
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	valor_tipo_area_infra_trans_aereo varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE infra_trans_aereo (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POINT, 3763) NOT NULL,
	codigo_iata varchar(255) NOT NULL,
	codigo_icao varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	valor_categoria_infra_trans_aereo varchar(10) NOT NULL,
	valor_restricao_infra_trans_aereo varchar(10) NOT NULL,
	valor_tipo_infra_trans_aereo varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

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

CREATE TABLE seg_lin_ferrea (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	eletrific bool NOT NULL,
	gestao varchar(255) NOT NULL,
	velocidade_max int4 NOT NULL,
	codigo_ferroviario varchar(255) NOT NULL,
	valor_categoria_bitola varchar(10) NOT NULL,
	valor_estado_linha_ferrea varchar(10) NOT NULL,
	valor_posicao_vertical_transportes varchar(10) NOT NULL,
	valor_tipo_linha_ferrea varchar(10) NOT NULL,
	valor_tipo_troco_linha_ferrea varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE linha_ferrea (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	codigo_ferroviario varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE area_infra_trans_ferrov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	infra_trans_ferrov_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE infra_trans_ferrov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POINT, 3763) NOT NULL,
	codigo_infra_ferrov varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	nplataformas int4 NOT NULL,
	no_trans_ferrov_id uuid NOT NULL,
	valor_tipo_uso_infra_trans_ferrov varchar(10) NOT NULL,
	valor_tipo_infra_trans_ferrov varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE no_trans_ferrov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	geometria geometry(POINT, 3763) NOT NULL,
	inicio_objeto date NOT NULL,
	fim_objeto date NOT NULL,
	valor_tipo_no_trans_ferrov varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE lig_seglinferrea_linhaferrea (
	seg_lin_ferrea_id uuid NOT NULL,
	linha_ferrea_id uuid NOT NULL,
	PRIMARY KEY (seg_lin_ferrea_id, linha_ferrea_id)
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

CREATE TABLE valor_tipo_troco_linha_ferrea (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_estado_linha_ferrea (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_linha_ferrovia (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_via_ferroviaria (
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

ALTER TABLE seg_lin_ferrea ADD CONSTRAINT valor_categoria_bitola_id FOREIGN KEY (valor_categoria_bitola) REFERENCES valor_categoria_bitola (identificador);
ALTER TABLE seg_lin_ferrea ADD CONSTRAINT valor_estado_linha_ferrea_id FOREIGN KEY (valor_estado_linha_ferrea) REFERENCES valor_estado_linha_ferrea (identificador);
ALTER TABLE seg_lin_ferrea ADD CONSTRAINT valor_posicao_vertical_transportes_id FOREIGN KEY (valor_posicao_vertical_transportes) REFERENCES valor_posicao_vertical_transportes (identificador);
ALTER TABLE seg_lin_ferrea ADD CONSTRAINT valor_tipo_linha_ferrea_id FOREIGN KEY (valor_tipo_linha_ferrea) REFERENCES valor_tipo_linha_ferrea (identificador);
ALTER TABLE seg_lin_ferrea ADD CONSTRAINT valor_tipo_troco_linha_ferrea_id FOREIGN KEY (valor_tipo_troco_linha_ferrea) REFERENCES valor_tipo_troco_linha_ferrea (identificador);
ALTER TABLE infra_trans_ferrov ADD CONSTRAINT valor_tipo_uso_infra_trans_ferrov_id FOREIGN KEY (valor_tipo_uso_infra_trans_ferrov) REFERENCES valor_tipo_uso_infra_trans_ferrov (identificador);
ALTER TABLE infra_trans_ferrov ADD CONSTRAINT valor_tipo_infra_trans_ferrov_id FOREIGN KEY (valor_tipo_infra_trans_ferrov) REFERENCES valor_tipo_infra_trans_ferrov (identificador);
ALTER TABLE no_trans_ferrov ADD CONSTRAINT valor_tipo_no_trans_ferrov_id FOREIGN KEY (valor_tipo_no_trans_ferrov) REFERENCES valor_tipo_no_trans_ferrov (identificador);

/**
 * Criar dominio Transporte Rodoviario
 */

CREATE TABLE seg_via_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	codigo_via_rodov varchar(14),
	gestao varchar(255) NOT NULL,
	largura_via_rodov int4 NOT NULL,
	multipla_faixa_rodagem bool NOT NULL,
	num_vias_transito int4 NOT NULL,
	pavimentado bool NOT NULL,
	velocidade_max int4 NOT NULL,
	jurisdicao varchar(255) NOT NULL,
	valor_caract_fisica_rodov varchar(10) NOT NULL,
	valor_estado_via_rodov varchar(10) NOT NULL,
	valor_posicao_vertical_transportes varchar(10) NOT NULL,
	valor_restricao_acesso varchar(10) NOT NULL,
	valor_sentido varchar(10) NOT NULL,
	valor_tipo_circulacao varchar(10) NOT NULL,
	valor_tipo_troco_rodoviario varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE area_infra_trans_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	infra_trans_rodov_id uuid NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE infra_trans_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	geometria geometry(POINT, 3763) NOT NULL,
	inicio_objeto date NOT NULL,
	fim_objeto date NOT NULL,
	nome varchar(255) NOT NULL,
	no_trans_rodov_id uuid NOT NULL,
	valor_tipo_infra_trans_rodov varchar(10),
	valor_tipo_servico varchar(10),
	PRIMARY KEY (identificador)
);

CREATE TABLE no_trans_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	geometria geometry(POINT, 3763) NOT NULL,
	inicio_objeto date NOT NULL,
	fim_objeto date NOT NULL,
	valor_tipo_no_trans_rodov varchar(10),
	PRIMARY KEY (identificador)
);

CREATE TABLE via_rodov (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	codigo_via_rodov varchar(255) NOT NULL,
	data_cat date NOT NULL,
	fonte_aquisicao_dados varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	nome_alternativo varchar(255),
	tipo_rodovia_abv varchar(255) NOT NULL,
	tipo_rodovia_c varchar(255) NOT NULL,
	tipo_rodovia_d varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE via_rodov_limite (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	codigo_via_rodov varchar(255),
	valor_tipo_limite varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE obra_arte (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	nome varchar(255),
	valor_tipo_obra_arte varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE lig_segviarodov_viarodov (
	seg_via_rodov_id uuid NOT NULL,
	via_rodov_id uuid NOT NULL,
	PRIMARY KEY (seg_via_rodov_id, via_rodov_id)
);

CREATE TABLE lig_viarodovlimite_viarodov (
	via_rodov_limite_id uuid NOT NULL,
	via_rodov_id uuid NOT NULL,
	PRIMARY KEY (via_rodov_limite_id, via_rodov_id)
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

ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_caract_fisica_rodov_id FOREIGN KEY (valor_caract_fisica_rodov) REFERENCES valor_caract_fisica_rodov (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_estado_via_rodov_id FOREIGN KEY (valor_estado_via_rodov) REFERENCES valor_estado_via_rodov (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_posicao_vertical_transportes_id FOREIGN KEY (valor_posicao_vertical_transportes) REFERENCES valor_posicao_vertical_transportes (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_restricao_acesso_id FOREIGN KEY (valor_restricao_acesso) REFERENCES valor_restricao_acesso (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_sentido_id FOREIGN KEY (valor_sentido) REFERENCES valor_sentido (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_tipo_circulacao_id FOREIGN KEY (valor_tipo_circulacao) REFERENCES valor_tipo_circulacao (identificador);
ALTER TABLE seg_via_rodov ADD CONSTRAINT valor_tipo_troco_rodoviario_id FOREIGN KEY (valor_tipo_troco_rodoviario) REFERENCES valor_tipo_troco_rodoviario (identificador);
ALTER TABLE infra_trans_rodov ADD CONSTRAINT valor_tipo_infra_trans_rodov_id FOREIGN KEY (valor_tipo_infra_trans_rodov) REFERENCES valor_tipo_infra_trans_rodov (identificador);
ALTER TABLE infra_trans_rodov ADD CONSTRAINT valor_tipo_servico_id FOREIGN KEY (valor_tipo_servico) REFERENCES valor_tipo_servico (identificador);
ALTER TABLE no_trans_rodov ADD CONSTRAINT valor_tipo_no_trans_rodov_id FOREIGN KEY (valor_tipo_no_trans_rodov) REFERENCES valor_tipo_no_trans_rodov (identificador);
ALTER TABLE via_rodov_limite ADD CONSTRAINT valor_tipo_limite_id FOREIGN KEY (valor_tipo_limite) REFERENCES valor_tipo_limite (identificador);
ALTER TABLE obra_arte ADD CONSTRAINT valor_tipo_obra_arte_id FOREIGN KEY (valor_tipo_obra_arte) REFERENCES valor_tipo_obra_arte (identificador);

/**
 * Criar dominio Hidrografia
 */

CREATE TABLE nascente (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POINT, 3763) NOT NULL,
	nome varchar(255),
	valor_persistencia_hidrologica varchar(10) NOT NULL,
	valor_tipo_nascente varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE agua_lentica (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	nome varchar(255),
	cota_plena_armazenamento bool NOT NULL,
	data_fonte_dados DATE NOT NULL,
	mare bool NOT NULL,
	origem_natural bool NOT NULL,
	profundidade_media real NOT NULL,
	valor_agua_lentica varchar(10) NOT NULL,
	valor_persistencia_hidrologica varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE margem (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	nome varchar(255),
	valor_tipo_margem varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

-- Linha, Poligono
CREATE TABLE curso_de_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763) NOT NULL,
	nome varchar(255),
	comprimento real NOT NULL,
	delimitacao_conhecida bool NOT NULL,
	eixo bool NOT NULL,
	ficticio bool NOT NULL,
	largura real NOT NULL,
	ordem_hidrologica varchar(255) NOT NULL,
	origem_natural bool NOT NULL,
	valor_curso_de_agua varchar(10) NOT NULL,
	valor_estado_instalacao varchar(10) NOT NULL,
	valor_persistencia_hidrologica varchar(10) NOT NULL,
	valor_posicao_vertical varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

-- Ponto, Poligono
CREATE TABLE queda_de_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763) NOT NULL,
	nome varchar(255),
	altura real NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE zona_humida (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POLYGON, 3763) NOT NULL,
	nome varchar(255),
	mare bool NOT NULL,
	valor_zona_humida varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE no_hidrografico (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(POINT, 3763) NOT NULL,
	nome varchar(255),
	valor_tipo_no_hidrografico varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

-- Ponto, Poligono
CREATE TABLE barreira (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(GEOMETRY, 3763)NOT NULL,
	nome varchar(255),
	valor_barreira varchar(10) NOT NULL,
	valor_estado_instalacao varchar(10) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE fronteira_terra_agua (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	inicio_objeto date NOT NULL,
	fim_objeto time,
	geometria geometry(LINESTRING, 3763) NOT NULL,
	data_fonte_dados date NOT NULL,
	ilha bool NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_barreira (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_tipo_margem (
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

CREATE TABLE valor_origem (
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

CREATE TABLE valor_elemento_associado_rede_agua (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_estado_instalacao (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

CREATE TABLE valor_prop_gravidade (
	identificador varchar(10) NOT NULL,
	descricao varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

ALTER TABLE nascente ADD CONSTRAINT valor_persistencia_hidrologica_id FOREIGN KEY (valor_persistencia_hidrologica) REFERENCES valor_persistencia_hidrologica (identificador);
ALTER TABLE nascente ADD CONSTRAINT valor_tipo_nascente_id FOREIGN KEY (valor_tipo_nascente) REFERENCES valor_tipo_nascente (identificador);
ALTER TABLE agua_lentica ADD CONSTRAINT valor_agua_lentica_id FOREIGN KEY (valor_agua_lentica) REFERENCES valor_agua_lentica (identificador);
ALTER TABLE agua_lentica ADD CONSTRAINT valor_persistencia_hidrologica_id FOREIGN KEY (valor_persistencia_hidrologica) REFERENCES valor_persistencia_hidrologica (identificador);
ALTER TABLE margem ADD CONSTRAINT valor_tipo_margem_id FOREIGN KEY (valor_tipo_margem) REFERENCES valor_tipo_margem (identificador);
ALTER TABLE curso_de_agua ADD CONSTRAINT valor_curso_de_agua_id FOREIGN KEY (valor_curso_de_agua) REFERENCES valor_curso_de_agua (identificador);
ALTER TABLE curso_de_agua ADD CONSTRAINT valor_estado_instalacao_id FOREIGN KEY (valor_estado_instalacao) REFERENCES valor_estado_instalacao (identificador);
ALTER TABLE curso_de_agua ADD CONSTRAINT valor_persistencia_hidrologica_id FOREIGN KEY (valor_persistencia_hidrologica) REFERENCES valor_persistencia_hidrologica (identificador);
ALTER TABLE curso_de_agua ADD CONSTRAINT valor_posicao_vertical_id FOREIGN KEY (valor_posicao_vertical) REFERENCES valor_posicao_vertical (identificador);
ALTER TABLE zona_humida ADD CONSTRAINT valor_zona_humida_id FOREIGN KEY (valor_zona_humida) REFERENCES valor_zona_humida (identificador);
ALTER TABLE no_hidrografico ADD CONSTRAINT valor_tipo_no_hidrografico_id FOREIGN KEY (valor_tipo_no_hidrografico) REFERENCES valor_tipo_no_hidrografico (identificador);
ALTER TABLE barreira ADD CONSTRAINT valor_barreira_id FOREIGN KEY (valor_barreira) REFERENCES valor_barreira (identificador);
ALTER TABLE barreira ADD CONSTRAINT valor_estado_instalacao_id FOREIGN KEY (valor_estado_instalacao) REFERENCES valor_estado_instalacao (identificador);

/**
 * Criar tabela auxiliar
 */

CREATE TABLE auxiliar (
	identificador uuid NOT NULL DEFAULT uuid_generate_v1mc(),
	geometria geometry(POLYGON, 3763) NOT NULL,
	data time NOT NULL,
	nivel_de_detalhe varchar(255) NOT NULL,
	nome varchar(255) NOT NULL,
	nome_proprietario varchar(255) NOT NULL,
	nome_produtor varchar(255) NOT NULL,
	PRIMARY KEY (identificador)
);

/**
 * Criar relacoes entre tabelas
 */

/**
 * Dominio Ocupacao de Solos
 */

ALTER TABLE areas_artificializadas ADD CONSTRAINT localizacao_instalacao_ambiental FOREIGN KEY (inst_gestao_ambiental_id) REFERENCES inst_gestao_ambiental (identificador);
ALTER TABLE areas_artificializadas ADD CONSTRAINT localizacao_instalacao_producao FOREIGN KEY (inst_producao_id) REFERENCES inst_producao (identificador);

/**
 * Dominio Construcoes
 */

ALTER TABLE edificio ADD CONSTRAINT localizacao_instalacao_ambiental FOREIGN KEY (inst_gestao_ambiental_id) REFERENCES inst_gestao_ambiental (identificador);
ALTER TABLE edificio ADD CONSTRAINT localizacao_instalacao_producao FOREIGN KEY (inst_producao_id) REFERENCES inst_producao (identificador);
ALTER TABLE constru_polig ADD CONSTRAINT localizacao_instalacao_producao FOREIGN KEY (inst_producao_id) REFERENCES inst_producao (identificador);

/**
 * Dominio Infraestruturas e Servicos Publicos 
 */

ALTER TABLE lig_servicopublico_edificio ADD CONSTRAINT localizacao_servico_publico_1 FOREIGN KEY (servico_publico_id) REFERENCES servico_publico (identificador);
ALTER TABLE lig_servicopublico_edificio ADD CONSTRAINT localizacao_servico_publico_2 FOREIGN KEY (edificio_id) REFERENCES edificio (identificador);

/**
 * Dominio Transporte Ferroviario
 */

ALTER TABLE area_infra_trans_ferrov ADD CONSTRAINT area_infra_trans_ferrov FOREIGN KEY (infra_trans_ferrov_id) REFERENCES infra_trans_ferrov (identificador);
ALTER TABLE infra_trans_ferrov ADD CONSTRAINT infra_trans_ferrov FOREIGN KEY (no_trans_ferrov_id) REFERENCES no_trans_ferrov (identificador);
ALTER TABLE lig_seglinferrea_linhaferrea ADD CONSTRAINT codigo_ferroviario_1 FOREIGN KEY (seg_lin_ferrea_id) REFERENCES seg_lin_ferrea (identificador);
ALTER TABLE lig_seglinferrea_linhaferrea ADD CONSTRAINT codigo_ferroviario_2 FOREIGN KEY (linha_ferrea_id) REFERENCES linha_ferrea (identificador);

/**
 * Dominio Transporte Rodoviario
 */

ALTER TABLE area_infra_trans_rodov ADD CONSTRAINT area_infra_trans_rodov FOREIGN KEY (infra_trans_rodov_id) REFERENCES infra_trans_rodov (identificador);
ALTER TABLE infra_trans_rodov ADD CONSTRAINT infra_trans_rodov FOREIGN KEY (no_trans_rodov_id) REFERENCES no_trans_rodov (identificador);
ALTER TABLE lig_segviarodov_viarodov ADD CONSTRAINT codigo_via_rodov_1 FOREIGN KEY (seg_via_rodov_id) REFERENCES seg_via_rodov (identificador);
ALTER TABLE lig_segviarodov_viarodov ADD CONSTRAINT codigo_via_rodov_2 FOREIGN KEY (via_rodov_id) REFERENCES via_rodov (identificador);
ALTER TABLE lig_viarodovlimite_viarodov ADD CONSTRAINT codigo_via_rodov_3 FOREIGN KEY (via_rodov_limite_id) REFERENCES via_rodov_limite (identificador);
ALTER TABLE lig_viarodovlimite_viarodov ADD CONSTRAINT codigo_via_rodov_4 FOREIGN KEY (via_rodov_id) REFERENCES via_rodov (identificador);

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
CREATE OR REPLACE FUNCTION trigger_line_polygon_validation() RETURNS trigger AS $BODY$
BEGIN
if(st_geometrytype(NEW.geometria) like 'ST_Line' OR st_geometrytype(NEW.geometria) like 'ST_Polygon') then
	RETURN NEW;
end if;
RAISE EXCEPTION 'Invalid geometry type only line or polygon are accepted!';
END; 
$BODY$ LANGUAGE plpgsql VOLATILE;

/** 
 * Cria trigger dominio Equipamento Urbano
 */

CREATE TRIGGER equipamento_urbano_geometry_check
BEFORE INSERT ON "equipamento_urbano"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

/** 
 * Cria trigger dominio Infraestruturas e Servicos Publicos
 */

CREATE TRIGGER elem_assoc_pgq_geometry_check
BEFORE INSERT ON "elem_assoc_pgq"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

CREATE TRIGGER elem_assoc_agua_geometry_check
BEFORE INSERT ON "elem_assoc_agua"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

CREATE TRIGGER elem_assoc_eletricidade_geometry_check
BEFORE INSERT ON "elem_assoc_eletricidade"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

/** 
 * Cria trigger dominio Construcoes
 */

CREATE TRIGGER edifico_geometry_check
BEFORE INSERT ON "edificio"
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

CREATE TRIGGER constru_polig_geometry_check
BEFORE INSERT ON "constru_polig"
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
FOR EACH ROW EXECUTE PROCEDURE trigger_point_polygon_validation();

CREATE TRIGGER curso_de_agua_geometry_check
BEFORE INSERT ON "curso_de_agua"
FOR EACH ROW EXECUTE PROCEDURE trigger_line_polygon_validation();

/**
 * Criar utilizador com acesso de leitura
 */

CREATE ROLE leitor LOGIN PASSWORD 'leitor';
GRANT CONNECT ON DATABASE recart TO leitor;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO leitor;

/**
 * Criar utilizador com acesso de leitura e escrita
 */

CREATE ROLE editor LOGIN PASSWORD 'editor';
GRANT CONNECT ON DATABASE recart TO editor;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO editor;
GRANT INSERT ON ALL TABLES IN SCHEMA public TO editor;
GRANT UPDATE ON ALL TABLES IN SCHEMA public TO editor;

/**
 * Criar utilizador com acesso de administrador
 */

CREATE ROLE administrador LOGIN PASSWORD 'administrador';
GRANT CONNECT ON DATABASE recart TO administrador;
GRANT ALL PRIVILEGES ON DATABASE recart TO administrador;
