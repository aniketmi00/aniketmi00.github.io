---
title: Code sample
---

A quick check of how code looks. Inline code like `const x = 42` sits in text.

Python:

```python
from dataclasses import dataclass

@dataclass
class Point:
    x: int
    y: int

def distance(a: Point, b: Point) -> float:
    # Euclidean distance
    return ((a.x - b.x) ** 2 + (a.y - b.y) ** 2) ** 0.5

print(distance(Point(0, 0), Point(3, 4)))  # 5.0
```

JavaScript:

```js
const greet = (name = "world") => {
  const msg = `Hello, ${name}!`;
  console.log(msg);
  return msg;
};

greet("Aniket");
```

Shell:

```sh
# find large files
du -ah . | sort -rh | head -n 10
```

Delete this note (`_notes/code-sample.md`) whenever you like.
