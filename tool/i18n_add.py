#!/usr/bin/env python3
# tool/i18n_add.py — añade/mergea claves a un ARB preservando las existentes.
# Uso: python tool/i18n_add.py lib/l10n/app_en.arb additions_en.json
import json, sys, collections

arb_path, add_path = sys.argv[1], sys.argv[2]
with open(arb_path, encoding='utf-8') as f:
    data = json.load(f, object_pairs_hook=collections.OrderedDict)
with open(add_path, encoding='utf-8') as f:
    additions = json.load(f, object_pairs_hook=collections.OrderedDict)

for k, v in additions.items():
    data[k] = v  # sobrescribe si existe, añade si no

with open(arb_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write('\n')
print(f'OK: {arb_path} ahora tiene {len([k for k in data if not k.startswith("@@")])} entradas')
