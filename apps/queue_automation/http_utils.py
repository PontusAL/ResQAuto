import requests

def heartbeat():
    url = "https://postman-echo.com/get"
    try:
        resp = requests.get(url, timeout=5)
        resp.raise_for_status()  # raise an error if not 2xx
        payload = resp.json()
        return {
            "ok": True,
            "url": payload.get("url"),
            "origin": payload.get("origin")
        }
    except requests.RequestException as e:
        return {
            "ok": False,
            "error": str(e)
        }