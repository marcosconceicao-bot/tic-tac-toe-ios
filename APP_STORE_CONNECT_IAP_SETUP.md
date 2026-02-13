# 🛒 App Store Connect - In-App Purchases Setup

## 💎 GUIA COMPLETO PARA CONFIGURAR COMPRAS NO APP

**Para que o sistema premium funcione, você precisa configurar os produtos no App Store Connect.**

---

## 🎯 PRODUCT IDs IMPLEMENTADOS

### **1. Remove Ads (Non-Consumable)**
```
Product ID: com.marcos.tictactoe.adfree
Type: Non-Consumable
Price: $2.99 (ou R$ 9,90)
```

### **2. Premium Monthly (Auto-Renewable Subscription)**
```
Product ID: com.marcos.tictactoe.premium.monthly
Type: Auto-Renewable Subscription
Price: $4.99/month (ou R$ 14,90/mês)
```

### **3. Premium Yearly (Auto-Renewable Subscription)**
```
Product ID: com.marcos.tictactoe.premium.yearly
Type: Auto-Renewable Subscription
Price: $24.99/year (ou R$ 89,90/ano)
Savings: 58% vs monthly
```

### **4. Small Coin Pack (Consumable)**
```
Product ID: com.marcos.tictactoe.coins.small
Type: Consumable
Contents: 500 coins
Price: $0.99 (ou R$ 2,90)
```

### **5. Large Coin Pack (Consumable)**
```
Product ID: com.marcos.tictactoe.coins.large
Type: Consumable
Contents: 2,000 coins
Price: $4.99 (ou R$ 14,90)
Value: 4x better than small pack
```

---

## 📱 PASSO A PASSO - APP STORE CONNECT

### **Passo 1: Acesse App Store Connect**
1. **Login**: https://appstoreconnect.apple.com
2. **Apps** → Selecione seu Tic Tac Toe app
3. **Features** → **In-App Purchases**

### **Passo 2: Criar Remove Ads (Non-Consumable)**
1. **Clique "+"** → **Non-Consumable**
2. **Preencha**:
   - **Reference Name**: Remove Ads Forever
   - **Product ID**: `com.marcos.tictactoe.adfree`
   - **Cleared for Sale**: ✅ YES

3. **Pricing**:
   - **Price**: Tier 5 ($2.99)
   - **Availability**: All territories

4. **Localization** (Português):
   - **Display Name**: Remover Anúncios
   - **Description**: Remova todos os anúncios permanentemente e desfrute de uma experiência sem interrupções.

5. **Localization** (English):
   - **Display Name**: Remove Ads
   - **Description**: Remove all advertisements permanently and enjoy an uninterrupted gaming experience.

6. **Review Information**:
   - **Screenshot**: Upload screenshot mostrando o app sem ads
   - **Review Notes**: "Removes banner and interstitial ads from the app"

### **Passo 3: Criar Premium Subscriptions**

**3.1 Criar Subscription Group**
1. **Subscription Groups** → **Create**
2. **Reference Name**: Premium Features
3. **App Name**: Tic Tac Toe Premium

**3.2 Premium Monthly**
1. **Add Subscription**
2. **Preencha**:
   - **Reference Name**: Premium Monthly
   - **Product ID**: `com.marcos.tictactoe.premium.monthly`
   - **Subscription Duration**: 1 Month
   - **Subscription Group**: Premium Features

3. **Pricing**: 
   - **Price**: Tier 10 ($4.99)
   - **Introductory Offer**: 3 days free trial

4. **Localization** (Português):
   - **Display Name**: Premium Mensal
   - **Description**: Acesso completo a recursos premium: sem anúncios, moedas ilimitadas, todos os temas, desafios exclusivos e estatísticas avançadas.

5. **Localization** (English):
   - **Display Name**: Premium Monthly
   - **Description**: Full access to premium features: no ads, unlimited coins, all themes, exclusive challenges, and advanced statistics.

**3.3 Premium Yearly**
1. **Add Subscription**
2. **Preencha**:
   - **Reference Name**: Premium Yearly
   - **Product ID**: `com.marcos.tictactoe.premium.yearly`
   - **Subscription Duration**: 1 Year
   - **Subscription Group**: Premium Features

3. **Pricing**: 
   - **Price**: Tier 18 ($24.99)
   - **Introductory Offer**: 7 days free trial

4. **Localization** (Português):
   - **Display Name**: Premium Anual
   - **Description**: O melhor valor! Acesso completo a recursos premium por um ano inteiro. Economize 58% comparado ao plano mensal.

### **Passo 4: Criar Coin Packs (Consumables)**

**4.1 Small Coin Pack**
1. **Create** → **Consumable**
2. **Reference Name**: Small Coin Pack
3. **Product ID**: `com.marcos.tictactoe.coins.small`
4. **Price**: Tier 1 ($0.99)
5. **Display Name**: Pacote Pequeno de Moedas (500 moedas)
6. **Description**: Compre 500 moedas para desbloquear temas e power-ups na loja.

**4.2 Large Coin Pack**
1. **Create** → **Consumable**
2. **Reference Name**: Large Coin Pack
3. **Product ID**: `com.marcos.tictactoe.coins.large`
4. **Price**: Tier 10 ($4.99)
5. **Display Name**: Pacote Grande de Moedas (2.000 moedas)
6. **Description**: O melhor valor! 2.000 moedas para todas as suas compras na loja.

---

## ⚖️ CONFIGURAÇÕES LEGAIS

### **Subscription Terms & Conditions**
```
TERMS OF SERVICE - TIC TAC TOE PREMIUM

1. SUBSCRIPTION TERMS
- Monthly subscription automatically renews every month
- Yearly subscription automatically renews every year
- Payment charged to iTunes Account at confirmation of purchase

2. AUTO-RENEWAL
- Subscription automatically renews unless cancelled at least 24 hours before end of current period
- Account charged for renewal within 24 hours prior to end of current period
- Subscriptions may be managed and auto-renewal turned off in Account Settings

3. CANCELLATION
- Cancel anytime to avoid future charges
- Cancellation takes effect at end of current billing period
- No refund for unused portion of subscription period

4. FREE TRIAL
- Free trial period forfeited when purchasing subscription
- Unused free trial time forfeited upon purchase

5. PRIVACY
- We collect minimal data as outlined in our Privacy Policy
- No personal information sold to third parties
- Data used only to improve app experience

Contact: marcos@tictactoe-ios.com
Privacy Policy: [Your Privacy Policy URL]
```

### **Privacy URL Required**
- **URL**: Sua privacy policy (já criada em `AppStore/PRIVACY_POLICY.md`)
- **Upload para**: GitHub Pages ou seu servidor
- **Formato**: HTTPS obrigatório

---

## 🧪 TESTING SETUP

### **Sandbox Testing**
1. **App Store Connect**
2. **Users and Access** → **Sandbox Testers**
3. **Create sandbox Apple ID** para testing
4. **Test subscriptions** em device

### **TestFlight Testing**
1. **Upload build** com IAPs implementados
2. **Internal testing** com sandbox account
3. **Test all purchase flows**
4. **Verify premium features unlock**

---

## 💰 PRICING STRATEGY

### **Preços Recomendados Brasil**
- **Remove Ads**: R$ 9,90 (one-time)
- **Premium Monthly**: R$ 14,90/mês
- **Premium Yearly**: R$ 89,90/ano (save 50%)
- **Small Coins**: R$ 2,90 (500 coins)
- **Large Coins**: R$ 14,90 (2000 coins)

### **Revenue Projections com IAPs**
- **Month 1**: $200-800 (ads + some IAPs)
- **Month 3**: $1K-3K (premium subscriptions growing)
- **Month 6**: $3K-8K (mature subscription base)
- **Year 1**: $8K-20K/month (premium positioning)

### **Conversion Expectations**
- **Ad-free conversion**: 8-15% of users
- **Premium subscription**: 3-8% of users
- **Coin pack purchase**: 15-25% of users
- **Average revenue per user**: $2-8

---

## ⚠️ IMPORTANT NOTES

### **Before Submission**
- [ ] All 5 products configured in App Store Connect
- [ ] Screenshots uploaded for each product
- [ ] Localizations completed (PT + EN)
- [ ] Pricing configured for all territories
- [ ] Subscription group properly set up

### **Tax Information**
- **Required**: Bank and tax info in App Store Connect
- **Setup**: Agreements, Tax, and Banking
- **Revenue sharing**: Apple takes 30% (15% after year 1 for subscriptions)

### **App Review**
- **IAPs reviewed**: Along with app submission
- **Test account**: Provide sandbox account if needed
- **Review notes**: Explain premium features clearly

---

## ✅ FINAL CHECKLIST

**App Store Connect Setup:**
- [ ] Remove Ads product created ($2.99)
- [ ] Premium Monthly subscription ($4.99/month)
- [ ] Premium Yearly subscription ($24.99/year)
- [ ] Small Coin Pack ($0.99 - 500 coins)
- [ ] Large Coin Pack ($4.99 - 2000 coins)
- [ ] All localizations completed (PT + EN)
- [ ] Screenshots uploaded for each product
- [ ] Pricing configured for target markets
- [ ] Privacy policy URL added
- [ ] Subscription terms completed

**Technical Implementation:**
- [ ] PremiumManager.swift integrated
- [ ] Product IDs match App Store Connect
- [ ] StoreKit framework linked
- [ ] Purchase flows tested
- [ ] Restore purchases working
- [ ] Premium features unlock correctly
- [ ] Ad-free functionality verified

**Revenue Optimization:**
- [ ] Free trial periods configured
- [ ] Introductory pricing set
- [ ] Yearly subscription saves significant %
- [ ] Coin packs priced for value
- [ ] Premium features compelling enough

---

## 🚀 EXPECTED RESULTS

**With premium system implemented:**
- **Revenue multiplier**: 5-10x current potential
- **User lifetime value**: $5-15 per user
- **Subscription revenue**: Predictable monthly income
- **Premium positioning**: Higher quality perception
- **Competitive advantage**: Feature differentiation

**🎯 Target: $5K-15K/month revenue within 6 months!**

**⚡ Setup time: 2-3 hours in App Store Connect + Testing**