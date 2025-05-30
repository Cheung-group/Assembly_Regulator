import os
import re
import pandas as pd
import numpy as np

# Expected N values for each type
N_exp_dict = {
        1:59,
        2:66,
        3:254,
        4:313,
        5:107,
        6:17,
        7:123,
        8:40,
        9:57,
        10:111,
        11:31,
        12:88,
        13:133,
        14:50,
        15:76
    # Add more if needed
}

all_results = []

Vacc_ref = 3515.1
V_std_ref = 19.5

for filename in os.listdir():
    match = re.match(r'vacc_results(\d+)\.txt', filename)
    if match:
        type_num = int(match.group(1))
        N_exp = N_exp_dict[type_num]

        df = pd.read_csv(filename, delim_whitespace=True)
        dN = df['abd'] - N_exp
        dV_acc = (df['avg_vacc'] - Vacc_ref).round(1)
        dV_acc_std = (np.sqrt(df['std_vacc']**2 + V_std_ref**2)).round(1)


        result_df = pd.DataFrame({
            'type': type_num,
            'dN': dN,
            'dV_acc': dV_acc,
            'dV_acc_std': dV_acc_std
        })

        all_results.append(result_df)

combined_df = pd.concat(all_results, ignore_index=True)
combined_df.to_csv('all_processed_vacc.txt', index=False, sep='\t')
print("Wrote: all_processed_vacc.txt")

