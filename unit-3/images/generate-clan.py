"""Generate CLAN covariate comparison figure"""

import matplotlib.pyplot as plt
import numpy as np

NAVY = '#13294B'
CAROLINA_BLUE = '#4B9CD3'
ORANGE = '#E07C3E'
WARM_GRAY = '#B0A99F'
CREAM = '#F5F4F0'

plt.rcParams.update({
    'font.family': 'sans-serif',
    'font.sans-serif': ['Helvetica', 'Arial', 'DejaVu Sans'],
    'font.size': 12,
    'figure.facecolor': 'white',
})

fig, ax = plt.subplots(1, 1, figsize=(8, 4))

variables = ['comorbidities', 'age', 'prior_er_visits', 'female', 'income_quartile', 'rural']
differences = [1.8, 8.3, 0.9, -0.02, -0.3, 0.05]

colors = [ORANGE if abs(d) > 1 else CAROLINA_BLUE if abs(d) > 0.5 else WARM_GRAY
          for d in differences]

y_pos = np.arange(len(variables))
bars = ax.barh(y_pos, differences, color=colors, alpha=0.7, edgecolor=NAVY, linewidth=1)

ax.set_yticks(y_pos)
ax.set_yticklabels(variables, fontsize=11)
ax.axvline(x=0, color=NAVY, lw=1, alpha=0.4)
ax.set_xlabel('Difference in means (Q5 - Q1)', fontsize=11)
ax.set_title('CLAN: Most-Affected vs Least-Affected Groups',
            fontsize=14, fontweight='bold', color=NAVY)
ax.invert_yaxis()
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

# Annotations for top two
ax.annotate('+1.8 more\ncomorbidities', xy=(1.8, 0), xytext=(3.5, 0.8),
            fontsize=9, color=NAVY, style='italic',
            arrowprops=dict(arrowstyle='->', color=NAVY, lw=1))
ax.annotate('+8.3 years\nolder', xy=(8.3, 1), xytext=(5.5, 2.2),
            fontsize=9, color=NAVY, style='italic',
            arrowprops=dict(arrowstyle='->', color=NAVY, lw=1))

plt.tight_layout()
plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/output-clan.png',
            dpi=200, bbox_inches='tight', facecolor='white')
plt.close()
print("Done: output-clan.png")
