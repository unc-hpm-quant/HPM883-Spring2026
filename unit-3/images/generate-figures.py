"""Generate presentation figures for Session 3.0: Causal Random Forests"""

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

# ── Style settings ──────────────────────────────────────────────
plt.rcParams.update({
    'font.family': 'sans-serif',
    'font.sans-serif': ['Helvetica', 'Arial', 'DejaVu Sans'],
    'font.size': 14,
    'axes.facecolor': 'white',
    'figure.facecolor': 'white',
})

CAROLINA_BLUE = '#4B9CD3'
NAVY = '#13294B'
LIGHT_BLUE = '#7BB8E0'
CREAM = '#F5F4F0'
WARM_GRAY = '#B0A99F'
ORANGE = '#E07C3E'


# ── Figure 1: Honest Estimation Data Split ──────────────────────
def make_honest_split():
    fig, ax = plt.subplots(1, 1, figsize=(10, 4.5))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 5)
    ax.axis('off')

    # Full sample box
    full = mpatches.FancyBboxPatch(
        (0.3, 0.3), 9.4, 4.2,
        boxstyle="round,pad=0.15",
        facecolor=CREAM, edgecolor=NAVY, linewidth=2
    )
    ax.add_patch(full)
    ax.text(5, 4.15, 'Full Sample (n observations)',
            ha='center', va='center', fontsize=16, fontweight='bold', color=NAVY)

    # Splitting half
    split_box = mpatches.FancyBboxPatch(
        (0.7, 0.7), 3.8, 2.8,
        boxstyle="round,pad=0.12",
        facecolor=CAROLINA_BLUE, edgecolor=NAVY, linewidth=1.5, alpha=0.25
    )
    ax.add_patch(split_box)
    # Solid border on top
    split_border = mpatches.FancyBboxPatch(
        (0.7, 0.7), 3.8, 2.8,
        boxstyle="round,pad=0.12",
        facecolor='none', edgecolor=CAROLINA_BLUE, linewidth=2.5
    )
    ax.add_patch(split_border)

    ax.text(2.6, 3.0, 'Splitting Half', ha='center', va='center',
            fontsize=15, fontweight='bold', color=NAVY)
    ax.text(2.6, 2.3, 'Build tree\nstructure', ha='center', va='center',
            fontsize=12, color=NAVY, style='italic')
    ax.text(2.6, 1.2, '(50% of data)', ha='center', va='center',
            fontsize=11, color=WARM_GRAY)

    # Estimation half
    est_box = mpatches.FancyBboxPatch(
        (5.5, 0.7), 3.8, 2.8,
        boxstyle="round,pad=0.12",
        facecolor=ORANGE, edgecolor=NAVY, linewidth=1.5, alpha=0.2
    )
    ax.add_patch(est_box)
    est_border = mpatches.FancyBboxPatch(
        (5.5, 0.7), 3.8, 2.8,
        boxstyle="round,pad=0.12",
        facecolor='none', edgecolor=ORANGE, linewidth=2.5
    )
    ax.add_patch(est_border)

    ax.text(7.4, 3.0, 'Estimation Half', ha='center', va='center',
            fontsize=15, fontweight='bold', color=NAVY)
    ax.text(7.4, 2.3, 'Compute leaf\nestimates (τ̂)', ha='center', va='center',
            fontsize=12, color=NAVY, style='italic')
    ax.text(7.4, 1.2, '(50% of data)', ha='center', va='center',
            fontsize=11, color=WARM_GRAY)

    # Arrow between boxes
    ax.annotate('', xy=(5.35, 2.1), xytext=(4.65, 2.1),
                arrowprops=dict(arrowstyle='->', color=NAVY, lw=2))

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/honest-split.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("✓ honest-split.png")


# ── Figure 2: Causal Forest as Ensemble ─────────────────────────
def make_forest_ensemble():
    fig, ax = plt.subplots(1, 1, figsize=(10, 4))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.5)
    ax.axis('off')

    # Draw B trees
    tree_positions = [1.5, 3.5, 5.5, 7.5]
    tree_labels = ['Tree 1', 'Tree 2', 'Tree 3', f'Tree B']

    for i, (x, label) in enumerate(zip(tree_positions, tree_labels)):
        # Tree box
        alpha_val = 0.2 if i < 3 else 0.35
        box = mpatches.FancyBboxPatch(
            (x - 0.7, 1.8), 1.4, 1.8,
            boxstyle="round,pad=0.1",
            facecolor=CAROLINA_BLUE, edgecolor=NAVY,
            linewidth=1.5, alpha=alpha_val
        )
        ax.add_patch(box)
        border = mpatches.FancyBboxPatch(
            (x - 0.7, 1.8), 1.4, 1.8,
            boxstyle="round,pad=0.1",
            facecolor='none', edgecolor=CAROLINA_BLUE, linewidth=1.5
        )
        ax.add_patch(border)
        ax.text(x, 3.2, label, ha='center', va='center',
                fontsize=12, fontweight='bold', color=NAVY)

        # Mini tree icon inside
        ax.plot([x, x - 0.3, x], [2.8, 2.4, 2.4], color=NAVY, lw=1.2)
        ax.plot([x, x + 0.3, x], [2.8, 2.4, 2.4], color=NAVY, lw=1.2)
        ax.plot([x - 0.3, x - 0.45], [2.4, 2.15], color=NAVY, lw=1)
        ax.plot([x - 0.3, x - 0.15], [2.4, 2.15], color=NAVY, lw=1)
        ax.plot([x + 0.3, x + 0.15], [2.4, 2.15], color=NAVY, lw=1)
        ax.plot([x + 0.3, x + 0.45], [2.4, 2.15], color=NAVY, lw=1)

        # Arrow down to average
        ax.annotate('', xy=(x, 1.2), xytext=(x, 1.7),
                    arrowprops=dict(arrowstyle='->', color=NAVY, lw=1.5))

    # Dots between tree 3 and tree B
    ax.text(6.5, 2.7, '· · ·', ha='center', va='center',
            fontsize=20, color=WARM_GRAY)

    # Average box at bottom
    avg_box = mpatches.FancyBboxPatch(
        (2.5, 0.3), 5, 0.85,
        boxstyle="round,pad=0.1",
        facecolor=ORANGE, edgecolor=NAVY, linewidth=2, alpha=0.25
    )
    ax.add_patch(avg_box)
    avg_border = mpatches.FancyBboxPatch(
        (2.5, 0.3), 5, 0.85,
        boxstyle="round,pad=0.1",
        facecolor='none', edgecolor=ORANGE, linewidth=2
    )
    ax.add_patch(avg_border)
    ax.text(5, 0.72, 'Average predictions   >>   tau-hat(x)', ha='center', va='center',
            fontsize=14, fontweight='bold', color=NAVY)

    # Title
    ax.text(5, 4.2, 'Causal Random Forest: Ensemble of Honest Trees',
            ha='center', va='center', fontsize=15, fontweight='bold', color=NAVY)

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/causal-forest-ensemble.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("✓ causal-forest-ensemble.png")


# ── Figure 3: Local Centering Concept ───────────────────────────
def make_local_centering():
    fig, axes = plt.subplots(1, 2, figsize=(10, 4))

    np.random.seed(42)
    n = 80
    x = np.random.uniform(0, 5, n)
    d = np.random.binomial(1, 0.3 + 0.1 * x, n)
    y = 2 + 1.5 * x + 1.2 * d + np.random.normal(0, 1.5, n)

    # Left: Raw data
    ax = axes[0]
    colors = [CAROLINA_BLUE if di == 1 else WARM_GRAY for di in d]
    ax.scatter(x, y, c=colors, alpha=0.6, s=30, edgecolors='none')
    ax.set_xlabel('Covariate X', fontsize=12)
    ax.set_ylabel('Outcome Y', fontsize=12)
    ax.set_title('Raw Data', fontsize=14, fontweight='bold', color=NAVY)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    # Legend
    treated_patch = mpatches.Patch(color=CAROLINA_BLUE, alpha=0.6, label='Treated')
    control_patch = mpatches.Patch(color=WARM_GRAY, alpha=0.6, label='Control')
    ax.legend(handles=[treated_patch, control_patch], fontsize=10, loc='upper left')

    # Right: Residualized
    ax = axes[1]
    y_resid = y - (2 + 1.5 * x)  # remove m(x)
    d_resid = d - (0.3 + 0.1 * x)  # remove e(x)
    colors2 = [ORANGE if di > 0 else LIGHT_BLUE for di in d_resid]
    ax.scatter(d_resid, y_resid, c=colors2, alpha=0.6, s=30, edgecolors='none')
    ax.axhline(y=0, color=NAVY, lw=0.8, ls='--', alpha=0.4)
    ax.axvline(x=0, color=NAVY, lw=0.8, ls='--', alpha=0.4)
    ax.set_xlabel('Residualized Treatment D̃', fontsize=12)
    ax.set_ylabel('Residualized Outcome Ỹ', fontsize=12)
    ax.set_title('After Local Centering', fontsize=14, fontweight='bold', color=NAVY)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    plt.tight_layout()
    plt.savefig('/Users/sysylvia/Documents/Repos/HPM883-Spring2026/unit-3/images/local-centering.png',
                dpi=200, bbox_inches='tight', facecolor='white')
    plt.close()
    print("✓ local-centering.png")


if __name__ == '__main__':
    make_honest_split()
    make_forest_ensemble()
    make_local_centering()
    print("\nAll figures generated!")
