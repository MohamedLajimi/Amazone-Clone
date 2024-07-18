const express = require('express')
const adminRouter = express.Router()
const admin = require('../middlewares/admin')
const {Product} = require('../models/product')

adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try {
        const { name, description, quantity, price, images, category } = req.body
        let product = new Product({
            name, description, images, quantity, price, category
        })
        product = await product.save()
        return res.status(200).json(product)
    } catch (e) {
        return res.status(500).json({ error: e.msg })
    }
})

adminRouter.get('/admin/get-products', admin, async (req, res) => {
    try {
        const products = await Product.find({})
        return res.status(200).json(products);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

adminRouter.post('/admin/delete-product',admin, async(req,res)=>{
    
    try{
        const {id}=req.body
        await Product.findByIdAndDelete(id)
        return res.status(200).json({msg:'Product deleted successfully'})
    }catch(e){
        return res.status(500).json({error:e.msg})
    }
})


module.exports = adminRouter