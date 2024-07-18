// Imports from packages
const express=require('express')
const mongoose=require('mongoose')

// Imports from other files
const authRouter=require('./routes/auth')
const adminRouter=require('./routes/admin')
const productRouter = require('./routes/product')
const userRouter = require('./routes/user')

// Initialization
const port=3000
const app=express()
const DB="mongodb+srv://mohamed:database123@cluster0.rxpet75.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

// Middlewares
app.use(express.json())
app.use(authRouter)
app.use(adminRouter)
app.use(productRouter)
app.use(userRouter)

// Connections
mongoose.connect(DB).then(()=>{console.log('connection success')})
.catch((e)=>{console.log(e)})

app.listen(port,"0.0.0.0",()=>{
console.log(`connected at port ${port}`)
})
