# Leer archivo original
with open('archivo_original.txt', 'r') as original_file:
    lines = original_file.readlines()

# Filtrar registros y transformarlos según las condiciones dadas
records = []
seq_number = 1

# Procesar desde la segunda línea
for line in lines[1:]:
    # Verificar si la línea tiene la longitud adecuada y cumple con el criterio principal
    if len(line.strip()) == 65 and line[20:25].strip() in {"06000", "07000", "08000", "09000", "10000", "20000"}:
        try:
            source_account = line[10:19].strip()
            receiving_account = line[10:19].strip()
            amount = line[41:59].strip()
            settlement_date = line[31:39].strip()

            # Ajustar source_account para que tenga 15 caracteres con "1000/" en las primeras 5 posiciones
            source_account = f"1204/{source_account.zfill(10)}"
            receiving_cash_account = f"1300/{receiving_account.zfill(10)}"
            transaction_reference = f"ICT{settlement_date}{str(seq_number).zfill(3)}"
            payment_system = "ARS payment system"
            currency = "ARS"
            amount_str = amount.lstrip('0') #amount_str = f"{int(amount):018}"
            description = "TRF Saldos"
            corporate_action_reference = ""
            transaction_on_hold_csd = "0"
            transaction_on_hold_participant = "0"

            record = (
                f"{source_account};{receiving_cash_account};{transaction_reference};"
                f"{payment_system};{currency};{amount_str};{settlement_date};"
                f"{description};{corporate_action_reference};{transaction_on_hold_csd};"
                f"{transaction_on_hold_participant}"
            )

            records.append(record)
            seq_number += 1
        except ValueError as ve:
            print(f"Error de conversión en la línea: {line.strip()} - {ve}")
        except IndexError as ie:
            print(f"Error de índice en la línea: {line.strip()} - {ie}")

# Escribir archivo destino con la cabecera y los registros
with open('archivo_destino.txt', 'w') as destino_file:
    header = (
        "SourceCashAccount;ReceivingCashAccount;TransactionReference;PaymentSystem;"
        "Currency;Amount;SettlementDate;Description;CorporateActionReference;"
        "TransactionOnHoldCSD;TransactionOnHoldParticipant\n"
    )
    destino_file.write(header)
    
    for record in records:
        destino_file.write(record + "\n")

print("Archivo transformado y guardado como 'archivo_destino.txt'")
