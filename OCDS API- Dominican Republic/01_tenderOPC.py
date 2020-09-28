import pandas as pd
import numpy as np
import datetime as dt
import concurrent.futures
import threading
from unidecode import unidecode



def get_mapeo_procesosPT():
    options = {
        'desglose_procurementMethod': {
            'Comparación de Precios': 'open',
            'Compras Menores': 'open',
            'Compras por Debajo del Umbral': 'open',
            'Licitación Pública Internacional': 'open',
            'Licitación Pública Nacional': 'open',
            'Procesos de Excepción': 'direct',
            'procesos de excepcion seguridad nacional': 'direct', 
            'Licitación Restringida': 'limited',
            'Sorteo de Obras': 'selective'
        
        },
        'tender_status': {
            'Proceso publicado': 'planned', 
            'WaitingForPublicationDate':'planned', 
            'RepliesOpenningStarted':'active', 
            'Proceso con etapa cerrada': 'active',
            'En aprobación': 'active',
            'Fase del Pliego de Condiciones Específicas': 'active',
            'Abierto': 'active',
            'Cancelado': 'cancelled',
            'Proceso desierto': 'unsuccessful', 
            'Proceso adjudicado y celebrado': 'complete',
            'Rechazado': 'withdrawn'
        },
        'procurement_category': {
            'Bienes': 'goods', 
            'Obras':'works', 
            'Servicios':'services',           
        }}
    _mapeo_procesos = pd.read_sql(sql="""SELECT "t1"."CodigoProceso" as "tender/id",
  "t1"."Caratula" as "tender/title",
  "t1"."DescripcionProceso" as "tender/description",
  "t1"."EstadoProceso" as "tender/status0",
  "t2"."PhaseName" as "tender/status",
  "t1"."Modalidad" as "tender/procurementMethodDetails",
  "t1"."ObjetoDelProceso" as "tender/additionalProcurementCategories",
  "t1"."MontoEstimado" as "tender/value/amount",
  "t2"."ProcedureCurrencyCode"  as "tender/value/currency", 
  "t1"."CodigoUnidadCompra" as "tender/procuringEntity/id",
  "t1"."UnidadCompra" as "tender/procuringEntity/name",
  "t1"."FCH_INICIO_RECEP_OFERTAS" as "tender/tenderPeriod/startDate",
  "t1"."FCH_FIN_RECEP_OFERTAS" as "tender/tenderPeriod/endDate", 
  "t1"."FCH_PRIMERA_APERTURA" as "tender/awardPeriod/startDate",
  "t1"."FCH_ESTIMADA_ADJUDICACION" as "tender/awardPeriod/endDate", 
  "t1"."CreateDate" as "date",
  "t1"."CantidadContratosEnviados" as "Cantidad_de_Contratos",
  "t1"."URL" as "URL"
   from TRUNCATED as "t1"
   inner join  TRUNCATED as "t2"
   on "t1"."CodigoProceso" = "t2"."RequestReference" """, con=engine_pt.connect())
    
    mapeo_procesos1 = _mapeo_procesos
    
    mapeo_procesos1['ocid'] = 'ocds-6550wx-' + mapeo_procesos1['tender/id']
    mapeo_procesos1['id'] = mapeo_procesos1['tender/id']
    mapeo_procesos1['tender/procuringEntity/id'] = 'DO-UC-' + mapeo_procesos1['tender/procuringEntity/id']
    mapeo_procesos1['initiationType'] = 'tender'
    mapeo_procesos1['tender/procurementMethod'] = mapeo_procesos1['tender/procurementMethodDetails'].apply(lambda x: options['desglose_procurementMethod'].get(x,x))
    mapeo_procesos1['tender/status'] = mapeo_procesos1['tender/status'].apply(lambda x: options['tender_status'].get(x,x))
    mapeo_procesos1['tender/mainProcurementCategory'] = mapeo_procesos1['tender/additionalProcurementCategories'].apply(lambda x: options['procurement_category'].get(x,x))
    mapeo_procesos1['tender/tenderPeriod/startDate'] = pd.to_datetime(mapeo_procesos1['tender/tenderPeriod/startDate'], infer_datetime_format=True).dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    mapeo_procesos1['tender/tenderPeriod/endDate'] = pd.to_datetime(mapeo_procesos1['tender/tenderPeriod/endDate'], infer_datetime_format=True).dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    mapeo_procesos1['tender/awardPeriod/startDate'] = pd.to_datetime(mapeo_procesos1['tender/awardPeriod/startDate'], infer_datetime_format=True).dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    mapeo_procesos1['tender/awardPeriod/endDate']= pd.to_datetime(mapeo_procesos1['tender/awardPeriod/endDate'], infer_datetime_format=True).dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    mapeo_procesos1['date']= pd.to_datetime(mapeo_procesos1['date'], infer_datetime_format=True).dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    
    mapeo_procesos1= mapeo_procesos1[
            ['ocid',
            'id',
            'date',
            'initiationType',
            'tender/id',
            'tender/title',
            'tender/procurementMethod',
            'tender/procurementMethodDetails',
            'tender/status',
            'tender/mainProcurementCategory',
            'tender/value/amount',
            'tender/value/currency',
            'tender/procuringEntity/id',
            'tender/procuringEntity/name',
            'tender/tenderPeriod/startDate',
            'tender/tenderPeriod/endDate',
            'tender/awardPeriod/startDate',
            'tender/awardPeriod/endDate']]
    return mapeo_procesos1