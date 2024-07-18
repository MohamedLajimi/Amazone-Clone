const express = require('express')
const auth = require('../middlewares/auth')
const {Product} = require('../models/product')
const productRouter = express.Router()

productRouter.get('/api/products', auth, async (req, res) => {
    try {
        const category = req.query.category
        const products = await Product.find({ category })
        return res.status(200).json(products)
    } catch (e) {
        return res.status(500).json({ error: e.message })
    }
})

productRouter.get('/api/products/search/:name', auth, async (req, res) => {
    try {
        const name = req.params.name
        const products = await Product.find({ name: { $regex: name, $options: 'i' } })
        return res.status(200).json(products)
    } catch (e) {
        return res.status(500).json({ error: e.message })
    }
})

productRouter.post('/api/rate-product', auth, async (req, res) => {
    try {
        const { id, rating } = req.body;
        let product = await Product.findById(id);
        let existingRatingIndex = product.ratings.findIndex(r => r.userId == req.user);
        if (existingRatingIndex !== -1) {
            product.ratings.splice(existingRatingIndex, 1);
        }
        const ratingSchema = { userId: req.user, rating };
        product.ratings.push(ratingSchema);
        await product.save();
        console.log(product.ratings);
        console.log(product);
        return res.status(200).json(product);
    } catch (e) {
        console.error(e);
        return res.status(500).json({ error: e.message });
    }
});

productRouter.get('/api/deal-of-day', auth, async (req, res) => {
    try {
        let products = await Product.find({})
        products=products.sort((a,b)=>{
            let aSum=0
            let bSum=0
            for(let i=0;i<a.ratings.length;i++){
                aSum+=a.ratings[i].rating
            }
            for(let i=0;i<b.ratings.length;i++){
                bSum+=b.ratings[i].rating
            }
            return aSum-bSum
        })
        return res.status(200).json(products[0])
    } catch (e) {
        return res.status(500).json({ error: e.message })
    }
})

module.exports = productRouter