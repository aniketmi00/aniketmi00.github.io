---
layout: page
title: Home
id: home
permalink: /
---

{% assign posts = site.notes | sort: "date" | reverse %}

<div class="intro">
  <p>I'm Aniket. I work on model inference systems for <a href="https://www.hbomax.com">HBO Max</a> @ <a href="https://www.wbd.com">Warner Bros. Discovery</a>. I write about machine learning, systems I've built, and things I'm reading.</p>
  <div class="intro-social">
    {% include social-icons.html %}
  </div>
</div>

<div class="hero-toy" aria-hidden="true">
  <div class="hero-toy-monitor">
    <div class="hero-toy-screen" id="heroToyScreen">
      <div class="hero-toy-scanlines"></div>
      <div class="hero-toy-text" id="heroToyText"><span id="heroToyTyped"></span><span class="hero-toy-cursor"></span></div>
    </div>
    <div class="hero-toy-panel">
      <div class="hero-toy-led" id="heroToyLed"></div>
      <button class="hero-toy-switch" id="heroToyPower" type="button" tabindex="-1">
        <span class="hero-toy-switch-track"><span class="hero-toy-switch-knob"></span></span>
        <span class="hero-toy-switch-label">pwr</span>
      </button>
      <button class="hero-toy-switch" id="heroToyNext" type="button" tabindex="-1">
        <span class="hero-toy-switch-track"><span class="hero-toy-switch-knob"></span></span>
        <span class="hero-toy-switch-label">fp16</span>
      </button>
      <button class="hero-toy-switch" id="heroToyTheme" type="button" tabindex="-1">
        <span class="hero-toy-switch-track"><span class="hero-toy-switch-knob"></span></span>
        <span class="hero-toy-switch-label">dark</span>
      </button>
    </div>
  </div>
</div>

<script>
  (function () {
    var lines = [
      "booting inference-engine.py ...",
      "loading kv-cache ... 128k tokens",
      "p99 latency: 43ms",
      "no zombie requests today",
      "torch.compile: recompiling (again)",
      "status: serving, not silently failing"
    ];

    var screen = document.getElementById("heroToyScreen");
    var typed = document.getElementById("heroToyTyped");
    var led = document.getElementById("heroToyLed");
    var powerBtn = document.getElementById("heroToyPower");
    var nextBtn = document.getElementById("heroToyNext");
    var themeBtn = document.getElementById("heroToyTheme");
    var navThemeToggle = document.getElementById("theme-toggle");
    if (!screen || !typed) return;

    var lineIndex = 0;
    var isOn = true;
    var timer = null;

    function clearTimer() {
      if (timer) { clearTimeout(timer); timer = null; }
    }

    function typeLine(text, i, cb) {
      if (!isOn) return;
      typed.textContent = text.slice(0, i);
      if (i < text.length) {
        timer = setTimeout(function () { typeLine(text, i + 1, cb); }, 32);
      } else {
        timer = setTimeout(cb, 1400);
      }
    }

    function eraseLine(text, i, cb) {
      if (!isOn) return;
      typed.textContent = text.slice(0, i);
      if (i > 0) {
        timer = setTimeout(function () { eraseLine(text, i - 1, cb); }, 16);
      } else {
        timer = setTimeout(cb, 200);
      }
    }

    function playLine() {
      if (!isOn) return;
      var text = lines[lineIndex % lines.length];
      typeLine(text, 0, function () {
        eraseLine(text, text.length, function () {
          lineIndex++;
          playLine();
        });
      });
    }

    function setPower(on) {
      isOn = on;
      clearTimer();
      screen.classList.toggle("is-off", !on);
      powerBtn.classList.toggle("is-on", on);
      led.classList.toggle("is-on", on);
      if (on) {
        typed.textContent = "";
        playLine();
      } else {
        typed.textContent = "";
      }
    }

    powerBtn.addEventListener("click", function () { setPower(!isOn); });

    nextBtn.addEventListener("click", function () {
      if (!isOn) return;
      clearTimer();
      lineIndex++;
      typed.textContent = "";
      playLine();
      nextBtn.classList.add("is-on");
      setTimeout(function () { nextBtn.classList.remove("is-on"); }, 180);
    });

    function syncThemeSwitch() {
      var dark = document.documentElement.classList.contains("theme-dark") ||
        (!document.documentElement.classList.contains("theme-light") &&
          window.matchMedia("(prefers-color-scheme: dark)").matches);
      themeBtn.classList.toggle("is-on", dark);
    }

    themeBtn.addEventListener("click", function () {
      if (navThemeToggle) navThemeToggle.click();
      syncThemeSwitch();
    });

    syncThemeSwitch();
    setPower(true);
  })();
</script>

<hr>

<ul class="recent-notes">
  {% for note in posts %}
    <li>
      <span class="recent-date">{{ note.date | date: "%Y &middot; %m" }}</span>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
