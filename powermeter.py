import pandas as pd
import matplotlib.pyplot as plt

# Lees de Excel data
file_path = 'data.xlsx'
df = pd.read_excel(file_path)
print(df.shape)

# Zorg dat de 'time' kolom als datetime wordt behandeld
df['time'] = pd.to_datetime(df['time'], format='%d-%m-%Y %H:%M')

# Stel de tijd als index in voor betere visualisatie
df.set_index('time', inplace=True)

# Plot een aantal kolommen
plt.figure(figsize=(12, 6))

# Bijvoorbeeld: Import en Export data visualiseren
df[['Import T1 kWh', 'Import T2 kWh', 'Export T1 kWh', 'Export T2 kWh']].plot(ax=plt.gca())
plt.title('Import en Export KWh Over Tijd')
plt.ylabel('KWh')
plt.xlabel('Tijd')
plt.grid()
plt.legend(loc='lower left')

# Toon de plot
plt.tight_layout()
plt.show()

