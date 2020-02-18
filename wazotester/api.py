# Copyright 2019 The Wazo Authors  (see the AUTHORS file)
# SPDX-License-Identifier: GPL-3.0-or-later

import json
import re
import requests
import sys
import socket

from dotty_dict import dotty  # type: ignore
from uuid import uuid4


RE_VARIABLE = re.compile(r'\{([^}\.]+)\.([^}]+)\}').search


def api_client(apiurl: str, config: dict, stored_responses: dict, https_verify: bool):
    uri = config.get('uri', '/')
    method = config.get('method', 'POST')
    payload = config.get('payload', None)
    raw_payload = config.get('raw_payload', None)
    stored_responses['random'] = {'uuid4': uuid4()}
    ipaddr = socket.gethostbyname(socket.gethostname())
    stored_responses['ipaddr'] = {'ip': ipaddr}
    response_codes = [200, 204]

    variable_match = RE_VARIABLE(uri)
    if variable_match is not None:
        stored_response = dotty(stored_responses[variable_match.group(1)])
        uri = uri.replace(
            variable_match.group(0), str(stored_response[variable_match.group(2)])
        )

    if payload:
        for k, v in payload.items():
            if not isinstance(v, str):
                continue
            variable_match = RE_VARIABLE(v)
            if variable_match is None:
                continue
            stored_response = dotty(stored_responses[variable_match.group(1)])
            payload[k] = v.replace(
                variable_match.group(0), str(stored_response[variable_match.group(2)])
            )
    elif raw_payload:
        payload = raw_payload

    if method == 'POST':
        response = requests.post("%s%s" % (apiurl, uri), json=payload, verify=https_verify)
        if response.status_code not in response_codes:
            sys.exit(1)
        try:
            data = json.loads(response.text)
            if isinstance(data, dict):
                return data
            else:
                return None
        except Exception:
            return None
    elif method == 'DELETE':
        response = requests.delete("%s%s" % (apiurl, uri), verify=https_verify)
        return response.status_code == 200
