"""Generate GATES bar chart for Session 3.0"""

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

plt.rcParams.update({
    'font.family': 'sans-serif',
    'font.sans-serif': ['Helvetica', 'Arial', 'DejaVu Sans'],
    'font.size': 13,
    'figure.facecolor': 'white',
})

CAROLINA_BLUE = '#4B9CD3'
NAVY = '#13294B'
ORANGE = '#E07C3E'
WARM_GRAY = '#B0A99F'
CREAM = '#F5F4F0'


def make_gates():
    fig, ax = plt.subplots(1, 1, figsize=(9, 5))

    # Simulated GATES results (quintile ATEs with SEs)
    groups = ['Q1\n(least\nbenefit)', 'Q2', 'Q3', 'Q4', 'Q5\n(most\nbenefit)']
    ates = [-0.2, -0.6, -1.1, -1.8, -3.2]
    ses = [0.35, 0.30, 0.28, 0.32, 0.38]
    overall_ate = -1.3

    colors = [WARM_GRAY, WARM_GRAY, CAROLINA_BLUE, CAROLINA_BLUE, ORANGE]

    x = np.arange(len(groups))
    bars = ax.bar(x, ates, width=0.6, color=colors, alpha=0.7, edgecolor=NAVY, linewidth=1.2)

    # Error bars
    ax.errorbar(x, ates, yerr=[1.96 * s for s in ses],
                fmt='none', color=NAVY, capsize=6, capthick=1.5, lw=1.5)

    # ATE reference line
    ax.axhline(y=overall_ate, color=ORANGE, lw=2, linestyle='--', alpha=0.8)
    ax.text(4.55, overall_ate + 0.15, f'ATE = {overall_ate}',
            color=ORANGE, fontsize=11, fontweight='bold', ha='right')

    # Zero line
    ax.axhline(y=0, color=NAVY, lw=0.8, alpha=0.3)

    ax.set_xticks(x)
    ax.set_xticklabels(groups, fontsize=11)
    ax.set_ylabel('Estimated ATE (AIPW)', fontsize=13)
    ax.set_title('Group Average Treatment Effects (GATES)',
                fontsize=15, fontweight='bold', color=NAVY)

    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    # Annotation
    ax.annotate('Staircase pattern =\nreal heterogeneity',
                xy=(4, -3.2), xytext=(1.5, -3.8),
                fontsize=10, color=NAVY, style='italic',
                arrowprops=dict(arrowstyle='->', color=NAVY, lw=1.2),
                bbox=dict(boxstyle='round,pad=0.3', facecolor=CREAM,
                         edgecolor=WARM_GRAY, alpha=0.9))

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/gates-example.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("Done: gates-example.png")


if __name__ == '__main__':
    make_gates()
