"""Generate TOC curve figure for RATE/AUTOC slide"""

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
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

fig, ax = plt.subplots(1, 1, figsize=(8, 4.5))

# Simulate a TOC curve (targeting operator characteristic)
q = np.linspace(0.05, 1.0, 50)
# TOC: excess benefit of targeting top-q fraction vs random
toc = 1.8 * np.exp(-2.5 * q) + 0.15 * (1 - q)
toc[-1] = 0  # at q=1, treating everyone = no advantage

# Confidence band
toc_upper = toc + 0.3 * np.exp(-1.5 * q)
toc_lower = toc - 0.3 * np.exp(-1.5 * q)
toc_lower = np.maximum(toc_lower, -0.2)

# Fill area under curve (AUTOC)
ax.fill_between(q, 0, toc, alpha=0.15, color=CAROLINA_BLUE)
ax.plot(q, toc, color=CAROLINA_BLUE, lw=2.5, label='TOC curve')
ax.fill_between(q, toc_lower, toc_upper, alpha=0.1, color=CAROLINA_BLUE)
ax.plot(q, toc_upper, color=CAROLINA_BLUE, lw=0.8, ls='--', alpha=0.4)
ax.plot(q, toc_lower, color=CAROLINA_BLUE, lw=0.8, ls='--', alpha=0.4)

# Zero reference
ax.axhline(y=0, color=NAVY, lw=1, alpha=0.3)

# AUTOC annotation
autoc_val = np.trapezoid(toc, q)
ax.annotate(f'AUTOC = {autoc_val:.2f}\n(shaded area)',
            xy=(0.4, 0.35), xytext=(0.6, 1.2),
            fontsize=11, color=NAVY, fontweight='bold',
            arrowprops=dict(arrowstyle='->', color=NAVY, lw=1.2),
            bbox=dict(boxstyle='round,pad=0.3', facecolor=CREAM,
                     edgecolor=WARM_GRAY, alpha=0.9))

# Label the curve shape
ax.annotate('Treating top 20%:\n1.4 extra ER visits\nprevented vs random',
            xy=(0.2, toc[7]), xytext=(0.25, 1.6),
            fontsize=9, color=ORANGE, style='italic',
            arrowprops=dict(arrowstyle='->', color=ORANGE, lw=1))

ax.set_xlabel('Fraction treated (highest CATE first)', fontsize=12)
ax.set_ylabel('Excess benefit vs. random assignment', fontsize=12)
ax.set_title('Targeting Operator Characteristic (TOC) Curve',
            fontsize=14, fontweight='bold', color=NAVY)
ax.set_xlim(0, 1.02)
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/output-toc.png',
            dpi=200, bbox_inches='tight', facecolor='white')
plt.close()
print("Done: output-toc.png")
