
def test_register_user(client):
    """Testet die Benutzerregistrierung."""
    response = client.post('/auth/register', json={
        'email': 'test@example.com',
        'password': 'Password123!'
    })
    assert response.status_code == 201
    assert response.get_json()['message'] == 'User registered successfully.'


def test_register_existing_user(client):
    """Testet, dass keine doppelte Registrierung möglich ist."""
    client.post('/auth/register', json={
        'email': 'test@example.com',
        'password': 'Password123!'
    })
    response = client.post('/auth/register', json={
        'email': 'test@example.com',
        'password': 'Password123!'
    })
    assert response.status_code == 400
    assert response.get_json()['message'] == 'Email already registered.'


def test_login_success(client):
    """Testet den erfolgreichen Login."""
    client.post('/auth/register', json={
        'email': 'test@example.com',
        'password': 'Password123!'
    })
    response = client.post('/auth/login', json={
        'email': 'test@example.com',
        'password': 'Password123!'
    })
    assert response.status_code == 200
    assert response.get_json()['message'] == 'Login successful.'


def test_login_invalid_credentials(client):
    """Testet, dass falsche Anmeldedaten abgelehnt werden."""
    client.post('/auth/register', json={
        'email': 'test@example.com',
        'password': 'Password123!'
    })
    response = client.post('/auth/login', json={
        'email': 'test@example.com',
        'password': 'WrongPassword!'
    })
    assert response.status_code == 401
    assert response.get_json()['message'] == 'Invalid credentials.'
