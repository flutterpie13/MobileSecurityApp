import re
import requests


def check_sql_injection(url):
    """
    Prüft eine URL auf SQL-Injection-Schwachstellen.
    Args:
        url (str): Die zu testende URL.
    Returns:
        dict: Ergebnisse der Prüfung mit Status und Details.
    """
    # Bekannte SQL-Injection-Patterns
    sql_payloads = [
        "' OR '1'='1",
        "' OR '1'='1' --",
        "' OR 1=1#",
        "' OR 1=1--",
        "' OR 1=1/*",
        "admin' --",
        "admin'/*",
    ]

    vulnerabilities = []
    for payload in sql_payloads:
        test_url = f"{url}?id={payload}"
        try:
            response = requests.get(test_url, timeout=5)
            if response.status_code == 200 and "error" in response.text.lower():
                vulnerabilities.append({
                    "payload": payload,
                    # Erste 100 Zeichen der Antwort
                    "response": response.text[:100],
                })
        except requests.exceptions.RequestException as e:
            return {"status": "error", "message": str(e)}

    if vulnerabilities:
        return {"status": "vulnerable", "details": vulnerabilities}
    else:
        return {"status": "safe", "details": []}
