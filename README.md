## Cerințe  

### I. Simulare în R  

Se consideră o activitate care presupune parcurgerea secvențială a **n** etape. Timpul necesar finalizării etapei **i** de către o persoană **A** este o variabilă aleatoare $T_i \sim Exp(\lambda_i)$. După finalizarea etapei **i**, **A** va trece în etapa **i+1** cu probabilitatea $\alpha_i$ sau va opri lucrul cu probabilitatea $1 - \alpha_i$. Fie **T** timpul total petrecut de persoana **A** în realizarea activității respective.  

1. Construiți un algoritm în **R** care simulează $10^6$ valori pentru v.a. **T** și, în baza acestora, aproximați $E(T)$. Reprezentați grafic valorile obținute pentru **T**. Ce observații puteți face despre repartiția lui **T**?  
2. Calculați valoarea exactă a lui $E(T)$ și comparați cu valoarea obținută prin simulare.  
3. În baza simulărilor de la **1)** aproximați probabilitatea ca persoana **A** să finalizeze activitatea.  
4. În baza simulărilor de la **1)** aproximați probabilitatea ca persoana **A** să finalizeze activitatea într-un timp **≤ σ**.  
5. Determinați timpul minim și timpul maxim în care **A** finalizează activitatea. Reprezentați grafic timpii de finalizare din fiecare simulare. Ce observații puteți face despre repartiția acestor timpi?  
6. Aproximați probabilitatea ca **A** să se oprească înainte de etapa **k**, unde $1 < k \leq n$. Reprezentați grafic probabilitățile obținute. Ce observații puteți face despre repartiția probabilităților obținute?  

---

### II. Aplicație Shiny - Repartiția Negativ Binomială  

Construiți o aplicație **Shiny** care să prezinte cele **5 formulări alternative** pentru repartiția **Negativ Binomială**, cu toate parametrizările cunoscute și cu repartițiile înrudite, împreună cu exemple de utilizare.  

Cerințe:  

1. Reprezentarea grafică a funcției de masă și a funcției de repartiție cu diferiți parametri.  
2. Construirea unei animații care să evidențieze schimbarea formei funcțiilor pe măsură ce parametrii se modifică.  
3. Ilustrarea unor exemple de aplicații în care repartiția **Negativ Binomială** este relevantă.  

**Resurse utile:**  
- [Shiny Basics](https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/)  
- [Wikipedia - Negative Binomial Distribution](https://en.wikipedia.org/wiki/Negative_binomial_distribution)  

---

### III. Aplicație Shiny - Funcții de repartiție  

Construiți o aplicație **Shiny** care să reprezinte grafic funcțiile de repartiție pentru următoarele variabile aleatoare:  

1. $X = \sum_{i=1}^{n} X_i^2 - \sum_{i=1}^{n} X_i, \quad X_i \sim N(0,1)$  
2. $X = \sum_{i=1}^{n} X_i^2 - \sum_{i=1}^{n} X_i, \quad X_i \sim N(\mu, \sigma), \quad \mu, \sigma > 0$  
3. $X = \sum_{i=1}^{n} X_i + 2, \quad X_i \sim Exp(\lambda), \quad \lambda > 0$  
4. $X = \sum_{i=1}^{n} X_i - 3, \quad X_i \sim Pois(\lambda), \quad \lambda > 0$  
5. $X = \sum_{i=1}^{n} X_i - 5, \quad X_i \sim Binom(r, p), \quad r, p \in (0,1)$  

**Resurse utile:**  
- [Shiny Basics](https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/)  

---
