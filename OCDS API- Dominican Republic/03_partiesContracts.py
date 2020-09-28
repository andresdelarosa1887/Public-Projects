import pandas as pd
import numpy as np
import datetime as dt
import concurrent.futures
import threading
from unidecode import unidecode


def get_parties_procesos():
    _parties_procesos = pd.read_sql(sql=""" select "t1"."CodigoProceso" as "tender/id",
  "t1"."UnidadCompra" as "parties/0/name",
  "t1"."CodigoUnidadCompra" as "parties/0/id",
  "t2"."FullLocation" as "parties/0/address/streetAddress"
   from TRUNCATED as "t1"
   inner join  ContractNotice as "t2"
   on "t1"."CodigoProceso" = "t2"."RequestReference" """,
   con=engine_pt.connect())
    
    mapeo_parties1 = _parties_procesos
    
    ##Process Identifiers
    mapeo_parties1['ocid'] = 'ocds-6550wx-' + mapeo_parties1['tender/id']
    mapeo_parties1['id'] = mapeo_parties1['tender/id']
    
    ##Identifier Scheme
    mapeo_parties1['parties/0/identifier/scheme'] = 'DO-UC'
    mapeo_parties1['parties/0/identifier/id'] = mapeo_parties1['parties/0/id']
    mapeo_parties1['parties/0/identifier/legalName'] = mapeo_parties1['parties/0/name']
    mapeo_parties1['parties/0/id'] = 'DO-UC-'+  mapeo_parties1['parties/0/identifier/id']
    
    #Party Role
    mapeo_parties1['parties/0/roles'] = 'procuringEntity'
    
    mapeo_parties1= mapeo_parties1[
            ['parties/0/name',
            'parties/0/id',
            'parties/0/identifier/scheme', 
            'parties/0/identifier/id',
            'parties/0/roles']]
    
    return mapeo_parties1

def get_parties_contratos(): 
    options = {        
    'TipoPersonaRPENoEspecificada': {
            'Persona Natural': 'N/A',
            'Persona Jurídica': 'No clasificada',
            'Oficina Gubernamental': 'No clasificada',
            'Cooperativa': 'No clasificada',
            'Asociación Sin Fines de Lucro': 'No clasificada',
        },
        
        'ClasificacionRPE': {
            'Migración': 'No clasificada'
        },
        
        'PartiesDetalles': {
            'N/A': 'person',
            'Gran empresa': 'large',
            'Mediana empresa': 'medium',
            'Pequeña empresa': 'small',
            'Micro empresa': 'micro',
            'No clasificada': ''            
        },
        'genero': {
            'Femenino': 'female',
            'Masculino': 'male',
            'No Especificado': ''}
        }
            
    _parties_contratos = pd.read_sql(sql="""select "t1"."CodigoProceso" as "tender/id",
                                          "t1"."RPE" as "parties/0/id"
                                           from TRUNCATED as "t1" """,
   con=engine_pt.connect())
    
    parties_contratos= _parties_contratos
    
        ##Process Identifiers
    parties_contratos['ocid'] = 'ocds-6550wx-' + parties_contratos['tender/id']
    parties_contratos['id'] = parties_contratos['tender/id']
    
    
    _proveedores = pd.read_sql(sql=""" select "t1"."RazonSocial" as "parties/0/name",
                                "t1"."RPE" as "parties/0/id",
                                "t1"."Direccion" as "parties/0/address/streetAddress",
                                "t1"."Municipio" as "parties/0/address/locality",
                                "t1"."Provincia" as "parties/0/address/region",
                                "t1"."Genero",
                                "t1"."ClasificacionRPE",
                                "t1"."TipoPersona" 
                                 from TRUNCATED  as "t1" """, con=engine_sigef.connect())
    
    proveedores= _proveedores
    proveedores['clasificacion_empresarial'] = proveedores.apply(lambda x: options['TipoPersonaRPENoEspecificada'].get(x.TipoPersona, x.ClasificacionRPE) if x.ClasificacionRPE=='No Especificada' else (options['ClasificacionRPE'].get(x.ClasificacionRPE, x.ClasificacionRPE)), axis=1)
    #Extensions
    proveedores['parties/0/details/scale'] = proveedores['clasificacion_empresarial'].apply(lambda x: options['PartiesDetalles'].get(x,x))
    proveedores['parties/0/details/gender'] = proveedores['Genero'].apply(lambda x: options['genero'].get(x,x))
    
    ##Merging the party information
    parties_contratos['parties/0/id'] = parties_contratos['parties/0/id'].astype('float') 
    proveedores['parties/0/id'] = proveedores['parties/0/id'].astype('float') 
    
    mapeo_parties2 = pd.merge(parties_contratos, proveedores, left_on='parties/0/id', right_on='parties/0/id', how='left') 
    mapeo_parties2['parties/0/id'] = mapeo_parties2['parties/0/id'].astype('str') 
    

    
    ##Identifier Scheme
    mapeo_parties2['parties/0/identifier/scheme'] = 'DO-RPE'
    mapeo_parties2['parties/0/identifier/id'] = mapeo_parties2['parties/0/id']
    mapeo_parties2['parties/0/identifier/legalName'] = mapeo_parties2['parties/0/name']
    mapeo_parties2['parties/0/id'] = 'DO-UC-' +  mapeo_parties2['parties/0/identifier/id']
    
    #Party Role
    mapeo_parties2['parties/0/roles'] = 'supplier'
    
    mapeo_parties3= mapeo_parties2[
            ['ocid',
             'id',
            'parties/0/name',
            'parties/0/id',
            'parties/0/identifier/scheme', 
            'parties/0/identifier/id',
            'parties/0/roles']]

    mapeo_parties4=  mapeo_parties2[
        ['parties/0/id',
         'parties/0/identifier/legalName',
         'parties/0/address/streetAddress',
         'parties/0/address/locality',
         'parties/0/address/region',
         'parties/0/details/gender',
         'parties/0/details/scale']]
    
    
    
    mapeo_parties1= get_parties_procesos()
    
    frames = [mapeo_parties1, mapeo_parties3]
    completo= pd.concat(frames)
      
    completo2= pd.merge(completo, mapeo_parties4, left_on='parties/0/id', right_on='parties/0/id', how='left') 
    completo2.drop_duplicates()
    return completo2