import pandas as pd
import numpy as np
import datetime as dt
import concurrent.futures
import threading
from unidecode import unidecode


def get_mapeo_contratosPT():
    options = {
        'contract_status': {
            'En edición': 'pending', 
            'Expirado':'pending', 
            'Flujo aprobado':'pending', 
            'Flujo en aprobación': 'pending',
            'Flujo rechazado': 'pending',
            'Modificado': 'pending',
            
            'Activo': 'active',
            
            'Cancelado': 'cancelled',
            'Suspendido': 'cancelled',
            'Rescindido': 'cancelled',
            
            'Cerrado': 'terminated'
        }
    }
    _mapeo_contratos = pd.read_sql(sql="""SELECT "t1"."CodigoProceso" as "tender/id",
                                "t1"."CodigoContrato" as "contracts/0/id",
                                "t1"."EstadoContrato" as "contracts/0/status", 
                                "t1"."FechaAprobacion" as "contracts/0/dateSigned", 
                                "t1"."ValorContratado" as "contracts/0/value/amount", 
                                "t1"."Moneda" as "contracts/0/value/currency", 
                                "t1"."FechaInicioContrato" as "contracts/0/period/startDate", 
                                "t1"."FechaFinContrato" as "contracts/0/period/endDate",
                                "t1"."RazonSocial" as "contracts/0/suppliers/0/name", 
                                "t1"."RPE" as "contracts/0/suppliers/0/id",
                                "t2"."Caratula" as "contracts/0/title"
                                from ContratosPortalTransaccionalNew  as "t1"
                                inner join  vw_ProcesosCompras_Estadistico as "t2"
                                on "t1"."CodigoProceso" = "t2"."CodigoProceso" """, con=engine_pt.connect())
    
    mapeo_contratos1 = _mapeo_contratos
    

    mapeo_contratos1['ocid'] = 'ocds-6550wx-' + mapeo_contratos1['tender/id']
    mapeo_contratos1['id'] = mapeo_contratos1['tender/id']
    
    mapeo_contratos1['contracts/0/status'] = mapeo_contratos1['contracts/0/status'].apply(lambda x: options['contract_status'].get(x,x))
    mapeo_contratos1['contracts/0/awardID'] = mapeo_contratos1['contracts/0/id']
    
    mapeo_contratos1['contracts/0/suppliers/0/id'] = 'DO-RPE-' + mapeo_contratos1['contracts/0/suppliers/0/id']
    
    mapeo_contratos1['contracts/0/period/startDate'] = pd.to_datetime(mapeo_contratos1['contracts/0/period/startDate'], infer_datetime_format=True).dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    mapeo_contratos1['contracts/0/period/endDate'] = pd.to_datetime(mapeo_contratos1['contracts/0/period/endDate'], infer_datetime_format=True).dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    mapeo_contratos1['contracts/0/dateSigned']= pd.to_datetime(mapeo_contratos1['contracts/0/dateSigned'], infer_datetime_format=True).dt.strftime('%Y-%m-%dT%H:%M:%SZ')
    
    mapeo_contratos1= mapeo_contratos1[
            ['contracts/0/id',
            'contracts/0/awardID',
            'contracts/0/title', 
            'contracts/0/status',
            'contracts/0/period/startDate',
            'contracts/0/period/endDate', 
            'contracts/0/value/amount', 
            'contracts/0/value/currency',
            'contracts/0/dateSigned',
            'contracts/0/suppliers/0/id',
            'contracts/0/suppliers/0/name']]
    
    return mapeo_contratos1
