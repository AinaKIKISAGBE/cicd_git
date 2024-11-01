
from flask import Flask 
app=Flask(__name__)

@app.route('/')
def welcome():
    return "Hello, I'm Aina KIKI-SAGBE, your treacher, this is your 1st test flask"

if __name__=='__main__':
    app.run(host='0.0.0.0',
#            port=5000,
#            debug=True # debug=False 
            )





