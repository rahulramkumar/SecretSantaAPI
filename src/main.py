import json
import logging
import os
import sys
sys.path.append("package/")
# put imports outside std lib under this line so I don't have to figure out how to package things correctly thx
import participants

logging.basicConfig(level=logging.DEBUG, format='%(levelname)s-%(message)s')

def lambda_handler(event, context):
    print(event)
    path = event['path']

    router = get_router()
    if path in router:
        return router[path](event, context)

    return api_gw_response(status_code=404)


def status(event, context):
    return api_gw_response(body=f'OK')

def insert_user(event, context):
    body = event['body']
    if body is None:
        return api_gw_response(status_code=401, body=f'Missing request body')
    body = json.loads(body)
    if body['name'] is None:
        return api_gw_response(status_code=401, body=f'Missing required parameter \'name\'')

    try:
        participants.put_giver(body['name'])
    except Exception as e:
        logging.error("Exception inserting name {} into ddb table: {}".format(body['name'], str(e)))
        logging.debug(event)
        return api_gw_response(status_code=500, body=str(e))

    return api_gw_response(status_code=201)


def api_gw_response(body=None, status_code=200, headers=None):
    response = {
        "isBase64Encoded": False,
        "statusCode": status_code,
        "headers": headers
    }
    if headers is None:
        response['headers'] = {
            "Content-Type": "application/json"
        }
    if body is not None:
        response['body'] = json.dumps(body)

    return response


def get_router():
    stage = os.environ["stage"]
    base_router = {
        "/status": status,
        "/api/user/insert": insert_user
    }
    stage_router = {}
    for route in base_router.keys():
        stage_router["/{}".format(stage) + route] = base_router[route]

    return stage_router
