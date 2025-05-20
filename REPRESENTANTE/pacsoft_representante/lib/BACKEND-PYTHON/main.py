from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv
import mysql.connector
from fastapi.middleware.cors import CORSMiddleware
import os

app = FastAPI()
load_dotenv()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # ou especifique o endereço do seu frontend
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configuração do banco
db_config = {
    'host': os.getenv('DB_HOST'),
    'port': int(os.getenv('DB_PORT')),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME')
}


class LoginRequest(BaseModel):
    cpfCnpj: str
    senha: str

@app.post("/login")
def login(request: LoginRequest):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        "SELECT * FROM representantes WHERE (cpf = %s OR cnpj = %s) AND senha = %s",
        (request.cpfCnpj, request.cpfCnpj, request.senha)
    )
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    if user:
        return {"autenticado": True,
        "nome": user.get("nome"),
                }
    else:
        return {"autenticado": False}

# Exemplo de rota para listar clientes
#@app.get("/representantes")
#def listar_clientes():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM representantes")
    clientes = cursor.fetchall()
    cursor.close()
    conn.close()
    return clientes

@app.post("/representantes/{cpfCnpj}")
def obter_cliente(cpfCnpj: str):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT r.nome, r.cpf, r.cnpj, r.telefone, r.chave_pix AS pix, cb.agencia, cb.conta FROM representantes r LEFT JOIN conta_bancaria cb ON r.id = cb.id_representante WHERE r.cpf = %s OR r.cnpj = %s", (cpfCnpj, cpfCnpj))
    cliente = cursor.fetchone()
    if cliente:
        return cliente
    else:
        raise HTTPException(status_code=404, detail="Representante não encontrado")
    
    