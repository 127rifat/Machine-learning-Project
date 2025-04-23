# Machine Learning-Driven Smart HVAC Insulation: Adaptive Thermal Regulation Using Hydrogel-Based Materials

**Author:** Md Rifat Hossain  
**Course:** MANE 4962 – Final Project  

---

## 🔍 Project Summary

This project simulates heat flow through hydrogel-based insulation (like PNAM) using MATLAB and predicts insulation performance using machine learning models.

We vary thickness and external temperature profiles (sinusoidal, cosine, step), simulate temperature changes over time, and generate CSV data for ML training.

---

## 📂 Folder Structure

```
hydrogel-insulation-ml/
├── data/               ← Simulation results in CSV format
├── src/                ← MATLAB scripts for thermal simulation
├── notebooks/          ← Python notebooks for ML models
├── results/            ← Visualization outputs (plots, PCA scatter)
├── requirements.txt    ← Python dependencies
└── README.md           ← Project overview and documentation
```

---

## 📊 What’s Inside

### 🔧 Simulations
- MATLAB-based 1D transient heat conduction
- PNAM hydrogel insulation
- Thickness: 0.01–0.15 m
- Profiles: sinusoidal, cosine, step
- 3000s duration, 400 steps
- Outputs as CSV files

### 📁 Data Files
- `thermal_data.csv` — basic simulation
- `extended_thermal_data.csv` — full set with profile and thickness

Each row contains:
- `Thickness`, `Time`, `Outer_Temperature`, `Profile`

---

## 🧠 Machine Learning Models

Models:
- Linear Regression
- Random Forest
- FCNN (Fully Connected Neural Network)

Steps:
1. Load CSV
2. Clean + normalize
3. Apply PCA (optional)
4. Train + evaluate

Best Model: Random Forest + PCA (R² = 0.9808, MAE = 0.1822)

---

## 🚀 How to Run

1. Clone repo:
```bash
git clone https://github.com/yourusername/hydrogel-insulation-ml.git
cd hydrogel-insulation-ml
```

2. Install Python requirements:
```bash
pip install -r requirements.txt
```

3. Run notebooks in order:
- `Data Preparation Script.ipynb`
- `Model comparison with raw data.ipynb`
- `Model comparison with extended data and implementation of PCA.ipynb`

---

## 📦 requirements.txt

Include:

```
pandas
numpy
scikit-learn
matplotlib
seaborn
jupyterlab
```

---

## ✅ AI Disclosure

I used ChatGPT to help organize and write parts of this documentation.
