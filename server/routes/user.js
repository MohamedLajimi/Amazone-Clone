const express = require('express')
const { Product } = require('../models/product')
const User = require("../models/user")
const auth = require('../middlewares/auth')
const { Order } = require('../models/order')
const userRouter = express.Router()

userRouter.post('/api/add-to-cart', auth, async (req, res) => {
    try {
        const { id } = req.body
        const product = await Product.findById(id)
        let user = await User.findById(req.user)
        if (user.cart.length == 0) {
            user.cart.push({ product, quantity: 1 })
        } else {
            let productIsFound = false
            for (let i = 0; i < user.cart.length; i++) {
                if (productIsFound = user.cart[i].product._id.equals(product._id)) {
                    productIsFound = true
                }
            }
            if (productIsFound) {
                let productFound = user.cart.find((p) => p.product._id.equals(product._id))
                productFound.quantity += 1
            } else {
                user.cart.push({ product, quantity: 1 })
            }
        }
        user = await user.save()
        return res.status(200).json(user)
    } catch (e) {
        return res.status(500).json({ error: e.msg })
    }
})

userRouter.delete('/api/remove-from-cart/:id', auth, async (req, res) => {
    try {
        const { id } = req.params
        const product = await Product.findById(id)
        let user = await User.findById(req.user)
        for (let i = 0; i < user.cart.length; i++) {
            if (user.cart[i].product._id.equals(product._id)) {
                if(user.cart[i].quantity==1){
                    user.cart.splice(i, 1)
                }else{
                    user.cart[i].quantity-=1
                }
            }
        }
        user = await user.save()
        return res.status(200).json(user)
    } catch (e) {
        return res.status(500).json({ error: e.msg })
    }
})

userRouter.post('/api/save-user-address', auth, async (req, res) => {
    try {
        const { address } = req.body
        let user = await User.findById(req.user)
        user.address=address
        user = await user.save()
        return res.status(200).json(user)
    } catch (e) {
        return res.status(500).json({ error: e.msg })
    }
})

userRouter.post('/api/order', auth, async (req, res) => {
    try {
        const { cart, address, totalPrice } = req.body
        let products=[]
        for(let i=0;i<cart.length;i++){
            let product=await Product.findById(cart[i].product._id)
            if( product.quantity>=cart[i].quantity){
                product.quantity-=cart[i].quantity
                products.push({product,quantity:cart[i].quantity})
                await product.save()
            }
            else{
                return res.status(400).json({error:`${product.name} is out of stock !` })
            }
        }
        let user=User.findById(req.id)
        user.cart=[]
        await user.save()

        let order=new Order({
            products,
            totalPrice,
            address,
            userId:req.user,
            orderedAt:new Date().getTime()
        })
        order=await order.save()
        res.json(order)
        
    } catch (e) {
        return res.status(500).json({ error: e.msg })
    }
})

userRouter.get('/api/fetch-orders',auth,async(req, res)=>{
    try{
        const orders=await Order.find({userId:req.user})
        return res.json(orders)
    }catch(e){
        return res.status(500).json({ error: e.msg })
    }
})

module.exports = userRouter