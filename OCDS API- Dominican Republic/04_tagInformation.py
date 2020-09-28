import pandas as pd
import numpy as np
import datetime as dt
import concurrent.futures
import threading
from unidecode import unidecode



def mapeo_procesos_final(): 
    contratos= get_mapeo_contratosPT()
    procesos= get_mapeo_procesosPT()
    data_fortag= pd.merge(procesos, contratos, left_on='id', right_on='id', how='left') 
    
    only_tender = ["unsuccessful", "active", "cancelled", "planned", "complete"]
    proceso_tender_award_contrato = ["active", "cancelled", "complete", "planned", "unsuccessful"]
    contrato_tender_award_contrato = ["active", "cancelled", "pending", "terminated" ]
    
    data_fortag['tag'] = data_fortag\
    .apply(lambda x: "tender" 
           if (x['tender/status'] in (only_tender) and pd.isna(x['contracts/0/id']))
           else ("tender;award;contract" 
                 if (x['tender/status']in (proceso_tender_award_contrato) 
                     and x['contracts/0/status'] in (contrato_tender_award_contrato)) 
                 else "nill"), axis=1)
    
    
    data_fortag['ocid'] = 'ocds-6550wx-' + data_fortag['tender/id']
    
    data_for_tag= data_fortag[[
            'ocid',
            'id', 
            'tag']]
    
    data_for_tag.drop_duplicates()
    
    mapeo_procesos_final = pd.merge(procesos, data_for_tag, left_on='id', right_on='id', how='left')
    
    mapeo_procesos_final= mapeo_procesos_final[
            ['ocid',
            'id',
            'date',
             'tag',
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
    
    
    return data_for_tag

