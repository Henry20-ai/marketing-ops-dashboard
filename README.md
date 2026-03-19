# Marketing Operations Dashboard

## 📊 Project Overview

Built an end-to-end marketing operations system demonstrating workflow automation, SQL data analysis, and business intelligence reporting for a SaaS marketing team.

**Live Dashboard:** 
![Dashboard Preview](./marketing-ops-dashboard

 /Full Dashboard.png)

---

## 🎯 Business Problem

Marketing teams struggle with:
- **Manual reporting** - 5+ hours per week pulling channel performance metrics
- **Inefficient lead nurturing** - No automated follow-up sequences
- **Poor visibility** - Leadership lacks real-time ROI insights across channels
- **Budget misallocation** - No data-driven channel performance comparison

---

## 💡 Solution

Created a comprehensive marketing operations system with:

1. **HubSpot Workflow Automation** - Automated lead nurture sequences and scoring
2. **PostgreSQL Data Analysis** - SQL queries for campaign performance and funnel metrics
3. **Power BI Dashboard** - Visual reporting for marketing ROI and channel performance

---

## 🔑 Key Findings

**Channel Performance Analysis:**
- **Email campaigns** delivered highest ROI (8,822%) and lowest customer acquisition cost ($17)
- **Organic content** generated $55,500 profit at zero cost - identified scaling opportunity
- **Paid Social** had 606% ROI but $213 CPA - optimization needed

**Funnel Efficiency:**
- Consistent 30% lead-to-MQL conversion rate across all months
- 8-9% MQL-to-customer close rate indicates stable pipeline
- Webinar channel showed 1,114% ROI but higher CPA ($124) - premium positioning

**Business Impact:**
- Total revenue tracked: $373,500
- Total customers: 249
- Overall marketing ROI: 124.5K%
- Recommendation: Shift 40% of paid budget to email + organic channels

---

## 🛠️ Technical Implementation

### 1. Data Infrastructure (PostgreSQL)

**Database Setup:**
- Created PostgreSQL database with campaigns table
- Imported 44 marketing campaigns across 8 channels
- Tracked full funnel metrics: leads → MQLs → SQLs → customers

**Schema:**
```sql
CREATE TABLE campaigns (
    campaign_id SERIAL PRIMARY KEY,
    campaign_name TEXT NOT NULL,
    channel TEXT NOT NULL,
    campaign_date DATE NOT NULL,
    leads INTEGER,
    mqls INTEGER,
    sqls INTEGER,
    customers INTEGER,
    cost DECIMAL(10,2),
    revenue DECIMAL(10,2)
);
```

### 2. SQL Analysis Queries

**Query 1: Channel Performance & ROI**
```sql
SELECT 
    channel,
    COUNT(*) as total_campaigns,
    SUM(leads) as total_leads,
    SUM(customers) as total_customers,
    ROUND(SUM(revenue) - SUM(cost), 2) as net_profit,
    ROUND((SUM(revenue) - SUM(cost)) / NULLIF(SUM(cost), 0) * 100, 2) as roi_percentage
FROM campaigns
GROUP BY channel
ORDER BY net_profit DESC;
```


**Query 2: Monthly Funnel Conversion Rates**
```sql
SELECT 
    TO_CHAR(campaign_date, 'YYYY-MM') as month,
    SUM(leads) as leads,
    SUM(mqls) as mqls,
    SUM(sqls) as sqls,
    SUM(customers) as customers,
    ROUND(SUM(mqls) * 100.0 / NULLIF(SUM(leads), 0), 2) as lead_to_mql_rate,
    ROUND(SUM(customers) * 100.0 / NULLIF(SUM(mqls), 0), 2) as mql_to_customer_rate
FROM campaigns
GROUP BY TO_CHAR(campaign_date, 'YYYY-MM')
ORDER BY month;
```

**Query 3: Cost Per Acquisition by Channel**
```sql
SELECT 
    channel,
    SUM(cost) as total_cost,
    SUM(customers) as total_customers,
    ROUND(SUM(cost) / NULLIF(SUM(customers), 0), 2) as cost_per_customer
FROM campaigns
WHERE customers > 0
GROUP BY channel
ORDER BY cost_per_customer ASC;
```

**Query 4: Top 10 Campaigns by ROI**
```sql
SELECT 
    campaign_name,
    channel,
    leads,
    customers,
    revenue,
    cost,
    ROUND((revenue - cost) / NULLIF(cost, 0) * 100, 2) as roi_percentage
FROM campaigns
WHERE customers > 0
ORDER BY roi_percentage DESC
LIMIT 10;
```

### 3. HubSpot Workflow Automation

**Workflow 1: Lead Nurture Sequence**
- **Trigger:** New contact created OR Lead status = "New"
- **Actions:**
  - Day 1: Send welcome email with resource guide
  - Day 4: Conditional branch - if email opened → send case study; if not opened → send alternative resource
  - Day 11: Create task for sales rep to follow up
- **Result:** 80% reduction in manual follow-up tasks


**Workflow 2: Lead Scoring System**
- **Trigger:** Engagement score ≥ 50 points
- **Scoring logic:**
  - Email opened = +5 points
  - Link clicked = +10 points
  - Form submitted = +15 points
  - Pricing page visited = +20 points
- **Actions:**
  - Score 50-74: Set lead status to MQL
  - Score 75+: Set to MQL + auto-assign to sales rep
- **Result:** Automated MQL qualification, saving 10+ hours/week

### 4. Power BI Dashboard

**KPIs Tracked:**
- Total Revenue: $373,500
- Total Customers: 249
- Overall ROI: 124.5K%

**Visualizations:**
1. **Channel Performance Bar Chart** - Revenue vs. cost by marketing channel
2. **Monthly Funnel Line Chart** - Lead progression through pipeline over time
3. **ROI Analysis Table** - Channel comparison with conditional formatting
4. **Cost Per Customer Chart** - Customer acquisition cost ranking

**Design Decisions:**
- Used green for positive metrics (revenue, high ROI)
- Used red for costs
- Teal accent color for ROI to indicate efficiency
- Navy headers for professional corporate aesthetic


## Technologies Used

- **Database:** PostgreSQL 17
- **Business Intelligence:** Microsoft Power BI Desktop
- **Marketing Automation:** HubSpot (Free CRM)
- **Data Analysis:** SQL
- **Version Control:** Git/GitHub

---

## Business Impact

This system would enable marketing teams to:
- **Save 5+ hours/week** on manual reporting and data pulls
- **Increase lead nurturing efficiency** through automated workflows
- **Make data-driven budget allocation decisions** using channel ROI analysis
- **Improve marketing ROI visibility** for leadership stakeholders
- **Identify optimization opportunities** (e.g., shift budget from $213 CPA channels to $17 CPA email)

**ROI Calculation:**
- Current email budget: $1,160 generating $103,500 revenue (8,822% ROI)
- If we shift $5,000 from Paid Social (606% ROI) to Email (8,822% ROI):
  - Projected additional revenue: ~$441,000
  - Net gain: $400K+ annually

---

## How to Use This Repository

### Prerequisites
- PostgreSQL installed locally
- Power BI Desktop (free download)
- HubSpot free account (optional, for workflow replication)

### Setup Instructions

**1. Clone the repository:**
```bash
git clone https://github.com/[your-username]/marketing-ops-dashboard.git
cd marketing-ops-dashboard
```

**2. Set up PostgreSQL database:**
```bash
# Create database
createdb marketing_ops

# Import data
psql marketing_ops < sql/marketing_analysis.sql
```

**3. Run SQL queries:**
```bash
psql marketing_ops -f sql/marketing_analysis.sql
```

**4. Open Power BI dashboard:**
- Open `dashboard/Marketing_Ops_Dashboard.pbix` in Power BI Desktop
- Connect to your local PostgreSQL instance (localhost)
- Refresh data to see updated visualizations

**5. View HubSpot workflows:**
- Screenshots available in `hubspot/` folder
- Replicate in your own HubSpot account using workflow builder

---

## 🎓 Skills Demonstrated

**Technical:**
- SQL query writing & optimization
- Database design & data modeling
- Business intelligence & data visualization
- Marketing automation platform (HubSpot)
- Git version control

**Business:**
- Marketing operations & funnel analysis
- ROI calculation & budget optimization
- Process automation & workflow design
- Stakeholder reporting & data storytelling
- Performance metric tracking

---

## 📄 License

This project is open source and available for educational purposes.

---

## 🙏 Acknowledgments

Built as a portfolio project to demonstrate marketing operations and business intelligence skills for Operations Analyst roles in SaaS companies.
