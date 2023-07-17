---
layout: post
title: Use LaTeX in Python f-strings
date: 2023-07-17 12:10:00 -0400
tags: howto, python, latex, interpolation
categories:
published: true
---
Suppose you want to set the title of a graph that contains LaTeX symbols using f-strings. The regular workflow such as the one below:

```python
T_fluid = 283.5
ax.set_title(f"$T_{fluid}$ = {T_fluid:.1f}")
```

breaks, because Python tries to interpolate the nonexistent variable `fluid`. In other words, we need to somehow tell Python to distinguish between LaTeX curly braces and those used for interpolation. You can do this by using double curly braces for LaTeX, like so:

{% raw %}
```python
T_fluid = 283.5
ax.set_title(f"$T_{{fluid}}$ = {T_fluid:.1f}")
```
{% endraw %}

See [here](https://stackoverflow.com/a/60150093/3438239) for more details.
