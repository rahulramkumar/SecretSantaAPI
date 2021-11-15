import os

import boto3

def put_giver(name):
    dynamodb = boto3.resource('dynamodb')
    table_name = os.getenv('PARTICIPANTS_TABLE')

    table = dynamodb.Table(table_name)
    resp = table.put_item(
        Item={
            'Giver': name,
            'Recipient': "None (placeholder)"
        }
    )
    return resp