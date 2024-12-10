
def test_perform_scan(client):
    """Testet das Durchführen eines Scans."""
    response = client.post('/scan/perform', json={
        'scan_type': 'URL',
        'target': 'http://example.com'
    })
    assert response.status_code == 200
    assert response.get_json()['message'] == 'Scan performed successfully.'
    assert 'results' in response.get_json()


def test_scan_history(client):
    """Testet die Rückgabe der Scan-Historie."""
    client.post('/scan/perform', json={
        'scan_type': 'URL',
        'target': 'http://example.com'
    })
    response = client.get('/scan/history')
    assert response.status_code == 200
    history = response.get_json()
    assert len(history) == 1
    assert history[0]['scan_type'] == 'URL'
    assert history[0]['target'] == 'http://example.com'
