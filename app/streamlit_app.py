import streamlit as st
import pandas as pd

# Title and description
st.title("Flower Species")
st.write("Explore More.")

# Load your data (example CSV in data folder)
@st.cache_data
def load_data():
    return pd.read_csv('data/plant_viruses.csv')

df = load_data()

# Display data table
st.dataframe(df)

# Example filter: select virus family
families = df['family'].unique()
selected_family = st.selectbox('Select Virus Family', families)

filtered_df = df[df['family'] == selected_family]

# Show filtered data
st.write(f"Showing records for family: {selected_family}")
st.dataframe(filtered_df)

# Add other visualizations or analyses as needed...

