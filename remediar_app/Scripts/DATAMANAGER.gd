extends Node


var banco_path := "user://banco.json"
var data := {
	"medicamentos": []
}


func _ready():
	carregar_banco()


# ================================
# 🔵 CARREGAR BANCO
# ================================
func carregar_banco():
	if FileAccess.file_exists(banco_path):
		var file := FileAccess.open(banco_path, FileAccess.READ)
		var text := file.get_as_text()
		file.close()

		var json_data = JSON.parse_string(text)
		if json_data != null:
			data = json_data
	else:
		salvar_banco() # cria arquivo vazio


# ================================
# 🔵 SALVAR BANCO
# ================================
func salvar_banco():
	var file := FileAccess.open(banco_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


# ================================
# 🔵 ADICIONAR MEDICAMENTO
# ================================
func adicionar_medicamento(nome:String, quantidade:int):
	var novo_id = gerar_id()

	var medicamento = {
		"id": novo_id,
		"nome": nome,
		"quantidade": quantidade,
		"lembretes": []
	}

	data["medicamentos"].append(medicamento)
	salvar_banco()
	return novo_id


# ================================
# 🔵 GERAR ID ÚNICO
# ================================
func gerar_id():
	var maior = 0
	for m in data["medicamentos"]:
		if m["id"] > maior:
			maior = m["id"]
	return maior + 1


# ================================
# 🔵 ADICIONAR LEMBRETE
# ================================
func adicionar_lembrete(medicamento_id:int, dia_semana:String, hora:String, repetir:bool):
	for m in data["medicamentos"]:
		if m["id"] == medicamento_id:
			m["lembretes"].append({
				"dia_semana": dia_semana,
				"hora": hora,
				"repetir": repetir
			})
			salvar_banco()
			return true
	return false


# ================================
# 🔵 REMOVER MEDICAMENTO
# ================================
func remover_medicamento(id:int):
	for m in data["medicamentos"]:
		if m["id"] == id:
			data["medicamentos"].erase(m)
			salvar_banco()
			return true
	return false


# ================================
# 🔵 EDITAR QUANTIDADE
# ================================
func atualizar_quantidade(id:int, nova_qtd:int):
	for m in data["medicamentos"]:
		if m["id"] == id:
			m["quantidade"] = nova_qtd
			salvar_banco()
			return true
	return false


# ================================
# 🔵 LISTAR REMÉDIOS
# ================================
func listar_medicamentos():
	return data["medicamentos"]
