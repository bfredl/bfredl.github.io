import json
import os

import requests

API_TOKEN = os.environ["hugtoken"]

API_URL = "https://api-inference.huggingface.co/models/EleutherAI/gpt-neo-2.7B"
headers = {"Authorization": f"Bearer {API_TOKEN}"}

def query(payload):
    data = json.dumps(payload)
    response = requests.request("POST", API_URL, headers=headers, data=data)
    return json.loads(response.content.decode("utf-8"))

def texta(text):
    response = query(dict(inputs=text, options=dict(use_cache=False), parameters
=dict(top_p=0.9, repetition_penalty=1.9, max_new_tokens=250, max_time=30, num_re
turn_sequences=1)))
    try:
        return response[0]["generated_text"]
    except Exception:
        return response

