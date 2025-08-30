import streamlit as st
import datetime as dt
import datetime
import pandas as pd
import numpy as np
import plotly.express as px
st.set_page_config(layout="wide",page_title="Online_Food_Delivery_Service")
@st.cache_data
def load_data():
    df=pd.read_csv("Online_Food_Delivery_Services Cleaned.csv")
    return df
df=load_data()

st.sidebar.header("Filters")
cuisine_filter = st.sidebar.multiselect( "Cuisine Type",options=df['CuisineType'].unique(),default=df['CuisineType'].unique()
)
filtered_df = df[df['CuisineType'].isin(cuisine_filter)]

payment_filter = st.sidebar.multiselect( "Payment Method",options=df['PaymentMethod'].unique(),default=df['PaymentMethod'].unique()
)
filtered_df = filtered_df[filtered_df['PaymentMethod'].isin(payment_filter)]

status_filter = st.sidebar.multiselect(
    "Order Status",
    options=df['Status'].unique(),
    default=df['Status'].unique()
)
filtered_df = filtered_df[filtered_df['Status'].isin(status_filter)]


col1, col2, col3, col4 = st.columns(4)

total_revenue = filtered_df['Revenue'].sum()
if total_revenue >= 1_000_000:
    revenue_display = f"{total_revenue/1_000_000:.2f} M"
elif total_revenue >= 1_000:
    revenue_display = f"{total_revenue/1_000:.2f} K"
else:
    revenue_display = f"{total_revenue:.2f}"

total_orders = filtered_df['OrderID'].nunique()
total_customers = filtered_df['CustomerID_x'].nunique()
total_drivers = filtered_df['Driver_name'].nunique()

col1.metric("Total Revenue",  revenue_display)
col2.metric("Orders", total_orders)
col3.metric("Customers", total_customers)
col4.metric("Drivers", total_drivers)


tab1, tab2, tab3 = st.tabs(["📊Overview", "👫Customers", "🚴Drivers"])

with tab1:
    st.subheader("Revenue by Cuisine")
    top_n_cuisines = st.slider("Top N Cuisines", min_value=3, max_value=15, value=5)
    rev_cuisine = (filtered_df.groupby("CuisineType")["Revenue"].sum().sort_values(ascending=False).head(top_n_cuisines))
    fig1 = px.bar(rev_cuisine, x=rev_cuisine.index, y="Revenue", title="Revenue by Cuisine")
    st.plotly_chart(fig1)
    st.subheader("Revenue by PaymentMethod")
    pay_rev = filtered_df.groupby("PaymentMethod")["Revenue"].sum()
    fig = px.pie(values=pay_rev, names=pay_rev.index, title="Revenue by Payment Method")
    st.plotly_chart(fig)
    st.subheader("Average Revenue per Menu Item")
    menu_rev = filtered_df.groupby('Name').agg({'Revenue':'sum', 'Quantity':'sum'}).reset_index()
    menu_rev['AvgRevenue'] = menu_rev['Revenue'] / menu_rev['Quantity']
    top_menu = menu_rev.sort_values('AvgRevenue', ascending=False).head(15)
    fig_menu = px.bar(top_menu, x='Name', y='AvgRevenue', title="Top Menu Items by Average Revenue")
    st.plotly_chart(fig_menu)
    st.subheader("Order Status Distribution")
    status_counts = filtered_df['Status'].value_counts().reset_index()
    status_counts.columns = ['Status','Count']
    fig_funnel = px.funnel(status_counts, x='Count', y='Status', title="Order Status Funnel")
    st.plotly_chart(fig_funnel)


with tab2:
    st.subheader("Revenue by Customers")
    top_n_customers = st.slider("Top N Customers", min_value=5, max_value=30, value=10)
    rev_customers = (filtered_df.groupby("FullName")["Revenue"].sum().sort_values(ascending=False).head(top_n_customers))
    fig2 = px.bar(rev_customers, x=rev_customers.index, y="Revenue", title="Revenue by Customers")
    st.plotly_chart(fig2)
    st.subheader("Customer Order Frequency")
    freq_cust = filtered_df['FullName'].value_counts()
    fig8 = px.histogram(freq_cust, x=freq_cust.index, y=freq_cust.values, title="Customer Order Frequency")
    st.plotly_chart(fig8)
    st.subheader("Revenue by Customer Location (Treemap)")
    if 'Address' in filtered_df.columns:
        rev_location = filtered_df.groupby('Address')['Revenue'].sum().reset_index()
        fig_treemap = px.treemap(rev_location, path=['Address'], values='Revenue', color='Revenue', title="Revenue by Customer Location")
        st.plotly_chart(fig_treemap)
with tab3:
    st.subheader("Revenue by Drivers")
    top_n_drivers = st.slider("Top N Drivers", min_value=5, max_value=20, value=10)
    rev_drivers = (filtered_df.groupby("Driver_name")["Revenue"].sum().sort_values(ascending=False).head(top_n_drivers))
    fig3 = px.bar(rev_drivers, x=rev_drivers.index, y="Revenue", title="Revenue by Drivers")
    st.plotly_chart(fig3)
    driver_perf = filtered_df.groupby("Driver_name").agg({"Revenue":"sum", "OrderID":"count"})
    fig = px.scatter(driver_perf, x="OrderID", y="Revenue", size="Revenue", hover_name=driver_perf.index, title="Driver Performance")
    color_continuous_scale=px.colors.sequential.Viridis,
    fig.update_layout(
    xaxis_title="Number Of Orders",
    yaxis_title="Total Revenue"
)
    st.plotly_chart(fig)
    st.subheader("Revenue by Payment Method per Driver")
    top_n_drivers_stack = st.slider("Top N Drivers", min_value=3, max_value=20, value=10)
    driver_payment = filtered_df.groupby(['Driver_name','PaymentMethod'])['Revenue'].sum().reset_index()
    top_drivers = driver_payment.groupby('Driver_name')['Revenue'].sum().sort_values(ascending=False).head(top_n_drivers_stack).index
    driver_payment_filtered = driver_payment[driver_payment['Driver_name'].isin(top_drivers)]
    fig_stack = px.bar(driver_payment_filtered, x='Driver_name', y='Revenue', color='PaymentMethod', title="Driver Revenue by Payment Method")
    st.plotly_chart(fig_stack)
