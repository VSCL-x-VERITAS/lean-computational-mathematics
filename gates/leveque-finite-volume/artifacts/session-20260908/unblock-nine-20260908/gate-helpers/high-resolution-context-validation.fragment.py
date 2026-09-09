# A literal user addendum, separate from the coordinator-selected Q10 choice.
HIGH_RESOLUTION_RECEIPT = {
    'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/user-high-resolution-interpretation-20260908.json',
    'sha256': '5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a',
}
HIGH_RESOLUTION_CONTEXT = {
    'path': 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/directional-complete-repair-review/source-context-with-user-high-resolution-v2.json',
    'sha256': '71bd39828c9ba3c9d6dd49d9e84fe5f32c9b446ae830679607b7edfe3d2d2c5d',
}


def validate_scoped_context_receipts(request, extension, packet, source, configured, environment):
    """Bind exact literal receipts without changing their authority or judging them."""
    extra_path = HIGH_RESOLUTION_RECEIPT['path']
    has_extra = (extra_path in configured or any(item['path'] == extra_path for item in environment)
                 or any(item.get('path') == extra_path for item in extension['interpretation_receipts']))
    expected = [INHERITED_RECEIPT]
    if has_extra:
        require(request['row'] == 'LEV-CH01-DIMENSIONAL-SPLITTING',
                'the literal high-resolution answer is scoped only to the dimensional-splitting row')
        require(request['source_context_extension'] == HIGH_RESOLUTION_CONTEXT,
                'the high-resolution answer requires the exact reviewed extended source context')
        expected.append(HIGH_RESOLUTION_RECEIPT)
    else:
        require(request['source_context_extension'] != HIGH_RESOLUTION_CONTEXT,
                'the literal high-resolution answer cannot be silently omitted from its source context')
    require(extension['interpretation_receipts'] == expected,
            'source context must retain the exact original scoped receipts in their recorded order')
    exact = []
    for item in expected:
        path = source_context_environment(item, configured, environment)
        raw = path.read_bytes()
        receipt = source_context_json(path)
        require(receipt['kind'] == 'explicit user-adopted source interpretation'
                and receipt['source_sha256'] == source['sha256'], 'inherited authority/source mismatch')
        exact.append({'receipt': item, 'exact_receipt_bytes_utf8': raw.decode('utf-8'), 'exact_fields': receipt})
    require(packet['interpretation_receipts'] == exact,
            'literal inherited receipt bytes/fields or original authority/scope changed')
    return expected

