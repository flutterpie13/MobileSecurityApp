# schemas/scan_schema.py
from marshmallow import Schema, fields, ValidationError


def validate_scan_type(value):
    allowed = ['sql_injection', 'xss', 'csrf']  # Beispielwerte
    if value not in allowed:
        raise ValidationError('Invalid scan_type provided.')


class PerformScanSchema(Schema):
    scan_type = fields.Str(required=True, validate=validate_scan_type)
    target = fields.Str(required=True)
