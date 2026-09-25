-- Script para crear la base de datos de Gerencia Asistida
-- Generado a partir del diagrama BD MAQUIGOLDEN.json

-- 1. Tablas Maestras (Independientes, no tienen llaves foráneas)

CREATE TABLE IF NOT EXISTS maestra_proveedores (
    nit TEXT PRIMARY KEY,
    razon_social TEXT NOT NULL,
    nombre_comercial TEXT,
    cuenta TEXT,
    banco TEXT,
    correo TEXT,
    telefono TEXT,
    persona_de_contacto TEXT
);

CREATE TABLE IF NOT EXISTS movimientos_cartera (
    id_movimiento SERIAL PRIMARY KEY,
    movimiento TEXT NOT NULL -- Ej: 'Abono', 'Saldo Inicial'
);

CREATE TABLE IF NOT EXISTS empresas (
    id_empresa SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL -- Ej: 'Maquigolden', 'Blue sky', 'Rocanorte'
);

CREATE TABLE IF NOT EXISTS productos_eds (
    id_producto SERIAL PRIMARY KEY,
    producto TEXT NOT NULL -- Ej: 'ACPM', 'Corriente'
);

CREATE TABLE IF NOT EXISTS vehiculos (
    vehiculo TEXT PRIMARY KEY, -- Usualmente la placa
    tipo_vehiculo TEXT NOT NULL,
    nombre_vehiculo TEXT
);

CREATE TABLE IF NOT EXISTS actividad (
    id_actividad SERIAL PRIMARY KEY,
    actividad TEXT NOT NULL -- Ej: 'Mineria', 'Renta'
);

CREATE TABLE IF NOT EXISTS colaborador (
    documento TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    cargo TEXT
);

CREATE TABLE IF NOT EXISTS tipos_gastos (
    id_tipo_gasto SERIAL PRIMARY KEY,
    tipo TEXT NOT NULL -- Ej: 'Mantenimiento', 'Repuestos', 'Otros'
);

CREATE TABLE IF NOT EXISTS maestra_lubricantes (
    id_tipo_lubricante SERIAL PRIMARY KEY,
    nombre_lubricante TEXT NOT NULL,
    unidad_de_presentacion TEXT,
    ultimo_precio NUMERIC
);

CREATE TABLE IF NOT EXISTS tipo_mtto_programado (
    id_tipo_mantenimiento SERIAL PRIMARY KEY,
    tipo_de_mantenimiento TEXT NOT NULL
);

-- 2. Tablas Transaccionales (Dependen de las maestras)

CREATE TABLE IF NOT EXISTS cartera (
    id_movimiento SERIAL PRIMARY KEY,
    nit_proveedor TEXT REFERENCES maestra_proveedores(nit),
    id_tipo_movimiento INTEGER REFERENCES movimientos_cartera(id_movimiento),
    empresa_deudora INTEGER REFERENCES empresas(id_empresa),
    empresa_que_paga INTEGER REFERENCES empresas(id_empresa),
    valor NUMERIC NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS compra_acpm (
    consecutivo_compra SERIAL PRIMARY KEY,
    consecutivo_eds TEXT,
    fecha DATE DEFAULT CURRENT_DATE,
    factura TEXT,
    id_proveedor TEXT REFERENCES maestra_proveedores(nit),
    id_producto INTEGER REFERENCES productos_eds(id_producto),
    vehiculo TEXT REFERENCES vehiculos(vehiculo),
    canecas_entregadas NUMERIC,
    galones_comprados NUMERIC,
    precio_x_galon NUMERIC,
    kilometraje_horometro NUMERIC,
    id_colaborador TEXT REFERENCES colaborador(documento),
    id_actividad INTEGER REFERENCES actividad(id_actividad),
    observaciones TEXT
);

CREATE TABLE IF NOT EXISTS gastos (
    consecutivo_gasto SERIAL PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    factura TEXT,
    id_proveedor TEXT REFERENCES maestra_proveedores(nit),
    descripcion TEXT,
    id_clasificacion INTEGER REFERENCES tipos_gastos(id_tipo_gasto),
    vehiculo TEXT REFERENCES vehiculos(vehiculo),
    id_colaborador TEXT REFERENCES colaborador(documento),
    valor NUMERIC NOT NULL,
    id_actividad INTEGER REFERENCES actividad(id_actividad),
    observaciones TEXT
);

CREATE TABLE IF NOT EXISTS horas_maquina (
    consecutivo_registro SERIAL PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    vehiculo TEXT REFERENCES vehiculos(vehiculo),
    hora_inicio_gps TIME,
    hora_fin_gps TIME,
    horometro_inicial NUMERIC,
    horometro_final NUMERIC,
    id_operador TEXT REFERENCES colaborador(documento),
    id_actividad INTEGER REFERENCES actividad(id_actividad),
    acpm NUMERIC,
    orden_de_trabajo TEXT,
    fecha_ultima_lavada DATE,
    observaciones TEXT
);

CREATE TABLE IF NOT EXISTS inventario_acpm_mina (
    consecutivo_registro SERIAL PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    recibo TEXT,
    horometro NUMERIC,
    hora TIME,
    responsable_de_entrega TEXT REFERENCES colaborador(documento),
    responsable_de_recibir TEXT REFERENCES colaborador(documento),
    canecas NUMERIC,
    galones NUMERIC,
    movimiento TEXT, -- Ej: 'Entrada', 'Salida'
    destino TEXT,
    id_actividad INTEGER REFERENCES actividad(id_actividad),
    observaciones TEXT
);

CREATE TABLE IF NOT EXISTS lubricantes (
    consecutivo_registro SERIAL PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    id_tipo INTEGER REFERENCES maestra_lubricantes(id_tipo_lubricante),
    vehiculo TEXT REFERENCES vehiculos(vehiculo),
    horometro NUMERIC,
    kilometraje NUMERIC,
    cantidad NUMERIC,
    movimiento TEXT, -- Ej: 'Entrada', 'Salida'
    observaciones TEXT
);

CREATE TABLE IF NOT EXISTS operacion_volquetas_ceramica (
    consecutivo_registro SERIAL PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    ticket TEXT,
    vehiculo TEXT REFERENCES vehiculos(vehiculo),
    id_conductor TEXT REFERENCES colaborador(documento),
    toneladas NUMERIC,
    valor_tonelada NUMERIC,
    lote_sap TEXT,
    lote_interno TEXT,
    patio TEXT,
    porcentaje_pago_conductor NUMERIC,
    observaciones TEXT
);

CREATE TABLE IF NOT EXISTS operacion_volquetas_mina (
    consecutivo_registro SERIAL PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    certificado_origen TEXT,
    vehiculo TEXT REFERENCES vehiculos(vehiculo),
    id_conductor TEXT REFERENCES colaborador(documento),
    viajes_internos NUMERIC,
    valor_viaje NUMERIC,
    origen TEXT,
    destino TEXT,
    observaciones TEXT
);

CREATE TABLE IF NOT EXISTS mantenimientos_programados (
    consecutivo_registro SERIAL PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    id_tipo INTEGER REFERENCES tipo_mtto_programado(id_tipo_mantenimiento),
    vehiculo TEXT REFERENCES vehiculos(vehiculo),
    insumo_usado TEXT,
    unidad TEXT,
    cantidad NUMERIC,
    precio NUMERIC
);
