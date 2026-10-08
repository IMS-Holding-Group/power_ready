const express = require('express');
const fs = require('fs');
const path = require('path');

const router = express.Router();
const providersPath = path.join(__dirname, '..', 'providers.json');

// بيانات المصادر الافتراضية
const defaultProviders = [
  {
    id: 1,
    name: 'شركة الطاقة المتجددة السعودية',
    description: 'مزود رائد للطاقة الشمسية في المملكة العربية السعودية',
    location: 'الرياض',
  },
  {
    id: 2,
    name: 'مؤسسة الطاقة النظيفة',
    description: 'حلول شاملة للطاقة الشمسية للمنازل والشركات',
    location: 'جدة',
  },
  {
    id: 3,
    name: 'شركة الطاقة المستدامة',
    description: 'أنظمة الطاقة الشمسية عالية الجودة والكفاءة',
    location: 'الدمام',
  },
  {
    id: 4,
    name: 'مؤسسة الطاقة الخضراء',
    description: 'خبرة واسعة في تركيب وصيانة أنظمة الطاقة الشمسية',
    location: 'المدينة المنورة',
  },
];

// إنشاء ملف providers.json إذا لم يكن موجوداً
if (!fs.existsSync(providersPath)) {
  fs.writeFileSync(providersPath, JSON.stringify(defaultProviders, null, 2), 'utf8');
}

router.get('/', (req, res) => {
  try {
    if (fs.existsSync(providersPath)) {
      const providers = JSON.parse(fs.readFileSync(providersPath, 'utf8'));
      res.json(providers);
    } else {
      res.json(defaultProviders);
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

