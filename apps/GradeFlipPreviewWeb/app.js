(async function bootstrap() {
  const response = await fetch("./preview-state.json");
  const seed = await response.json();

  const state = {
    activeTab: "study",
    decks: structuredClone(seed.decks),
    selectedDeckId: seed.decks[0]?.id ?? null,
    selectedCardId: seed.decks[0]?.cards[0]?.id ?? null,
    studyShowsBack: false,
  };

  const elements = {
    tabButtons: Array.from(document.querySelectorAll(".tab-button")),
    views: {
      study: document.getElementById("study-view"),
      decks: document.getElementById("decks-view"),
    },
    viewTitle: document.getElementById("view-title"),
    studyDeckList: document.getElementById("study-deck-list"),
    studyProgress: document.getElementById("study-progress"),
    studyStarToggle: document.getElementById("study-star-toggle"),
    studyCard: document.getElementById("study-card"),
    studyFaceLabel: document.getElementById("study-face-label"),
    studyCardCopy: document.getElementById("study-card-copy"),
    studyNotePreview: document.getElementById("study-note-preview"),
    studyImageStrip: document.getElementById("study-image-strip"),
    studyPrevious: document.getElementById("study-previous"),
    studyFlip: document.getElementById("study-flip"),
    studyNext: document.getElementById("study-next"),
    editorDeckList: document.getElementById("editor-deck-list"),
    editorDeckTitle: document.getElementById("editor-deck-title"),
    deckTitleInput: document.getElementById("deck-title-input"),
    newCardFront: document.getElementById("new-card-front"),
    newCardBack: document.getElementById("new-card-back"),
    addCardButton: document.getElementById("add-card-button"),
    editorCardList: document.getElementById("editor-card-list"),
  };

  function currentDeck() {
    return state.decks.find((deck) => deck.id === state.selectedDeckId) ?? state.decks[0] ?? null;
  }

  function currentCard() {
    const deck = currentDeck();
    if (!deck) return null;
    return deck.cards.find((card) => card.id === state.selectedCardId) ?? deck.cards[0] ?? null;
  }

  function ensureSelection() {
    const deck = currentDeck();
    if (!deck && state.decks.length > 0) {
      state.selectedDeckId = state.decks[0].id;
    }
    const selected = currentDeck();
    if (selected && !selected.cards.some((card) => card.id === state.selectedCardId)) {
      state.selectedCardId = selected.cards[0]?.id ?? null;
    }
  }

  function setActiveTab(tab) {
    state.activeTab = tab;
    elements.viewTitle.textContent = tab === "study" ? "Study" : "Decks";
    elements.tabButtons.forEach((button) => {
      button.classList.toggle("is-active", button.dataset.tab === tab);
    });
    Object.entries(elements.views).forEach(([key, view]) => {
      view.classList.toggle("is-active", key === tab);
    });
  }

  function renderDeckList(target, clickHandler) {
    target.innerHTML = "";
    state.decks.forEach((deck) => {
      const cardCount = deck.cards.length;
      const activeClass = deck.id === state.selectedDeckId ? "deck-item is-active" : "deck-item";
      const wrapper = document.createElement("article");
      wrapper.className = activeClass;
      wrapper.innerHTML = `
        <button type="button" class="mini-button">
          <h4>${escapeHtml(deck.title)}</h4>
          <p>${cardCount} cards</p>
        </button>
      `;
      wrapper.querySelector("button").addEventListener("click", () => clickHandler(deck.id));
      target.appendChild(wrapper);
    });
  }

  function renderStudy() {
    ensureSelection();
    renderDeckList(elements.studyDeckList, (deckId) => {
      state.selectedDeckId = deckId;
      state.selectedCardId = currentDeck()?.cards[0]?.id ?? null;
      state.studyShowsBack = false;
      render();
    });

    const deck = currentDeck();
    const card = currentCard();
    if (!deck || !card) {
      elements.studyProgress.textContent = "0 / 0";
      elements.studyCardCopy.textContent = "No cards loaded";
      return;
    }

    const cardIndex = deck.cards.findIndex((item) => item.id === card.id);
    elements.studyProgress.textContent = `${cardIndex + 1} / ${deck.cards.length}`;
    elements.studyStarToggle.textContent = card.isStarred ? "★" : "☆";
    elements.studyFaceLabel.textContent = state.studyShowsBack ? "Back" : "Front";
    elements.studyCardCopy.textContent = state.studyShowsBack ? card.backText : card.frontText;
    elements.studyNotePreview.textContent = card.noteText || "Long-form note editing stays available in the deck editor.";
    elements.studyImageStrip.innerHTML = "";

    if (card.images.length === 0) {
      const empty = document.createElement("p");
      empty.className = "detail-copy";
      empty.textContent = "No image placeholders on this card.";
      elements.studyImageStrip.appendChild(empty);
    } else {
      card.images.forEach((image) => {
        const chip = document.createElement("div");
        chip.className = `image-chip ${image.tintName || "blue"}`;
        chip.textContent = image.filename;
        elements.studyImageStrip.appendChild(chip);
      });
    }

    elements.studyPrevious.disabled = cardIndex <= 0;
    elements.studyNext.disabled = cardIndex >= deck.cards.length - 1;
  }

  function renderDeckEditor() {
    ensureSelection();
    renderDeckList(elements.editorDeckList, (deckId) => {
      state.selectedDeckId = deckId;
      state.selectedCardId = currentDeck()?.cards[0]?.id ?? null;
      render();
    });

    const deck = currentDeck();
    if (!deck) {
      elements.editorDeckTitle.textContent = "Deck Editor";
      elements.editorCardList.innerHTML = "";
      return;
    }

    elements.editorDeckTitle.textContent = deck.title;
    elements.deckTitleInput.value = deck.title;
    elements.editorCardList.innerHTML = "";

    deck.cards.forEach((card) => {
      const index = deck.cards.findIndex((item) => item.id === card.id);
      const wrapper = document.createElement("article");
      wrapper.className = "card-editor";
      wrapper.innerHTML = `
        <div class="card-editor-header">
          <h4>Card ${index + 1}</h4>
          <span class="pill">${card.images.length} images</span>
        </div>
        <label class="field">
          <span>Front</span>
          <input type="text" data-card-field="frontText" value="${escapeAttribute(card.frontText)}">
        </label>
        <label class="field">
          <span>Back</span>
          <input type="text" data-card-field="backText" value="${escapeAttribute(card.backText)}">
        </label>
        <label class="field">
          <span>Note</span>
          <textarea data-card-field="noteText">${escapeHtml(card.noteText)}</textarea>
        </label>
        <div class="card-meta-row">
          <span class="pill">${card.images.map((image) => image.filename).join(", ") || "No images attached"}</span>
          <button type="button" class="mini-button">Use In Study</button>
        </div>
      `;

      wrapper.querySelectorAll("[data-card-field]").forEach((field) => {
        field.addEventListener("input", (event) => {
          deck.cards[index][event.target.dataset.cardField] = event.target.value;
          renderStudy();
        });
      });

      wrapper.querySelector(".mini-button").addEventListener("click", () => {
        state.selectedCardId = card.id;
        state.activeTab = "study";
        state.studyShowsBack = false;
        render();
      });

      elements.editorCardList.appendChild(wrapper);
    });
  }

  function render() {
    setActiveTab(state.activeTab);
    renderStudy();
    renderDeckEditor();
  }

  elements.tabButtons.forEach((button) => {
    button.addEventListener("click", () => {
      state.activeTab = button.dataset.tab;
      render();
    });
  });

  elements.studyCard.addEventListener("click", () => {
    state.studyShowsBack = !state.studyShowsBack;
    renderStudy();
  });

  elements.studyFlip.addEventListener("click", () => {
    state.studyShowsBack = !state.studyShowsBack;
    renderStudy();
  });

  elements.studyPrevious.addEventListener("click", () => {
    const deck = currentDeck();
    const card = currentCard();
    if (!deck || !card) return;
    const index = deck.cards.findIndex((item) => item.id === card.id);
    state.selectedCardId = deck.cards[Math.max(index - 1, 0)]?.id ?? card.id;
    state.studyShowsBack = false;
    renderStudy();
  });

  elements.studyNext.addEventListener("click", () => {
    const deck = currentDeck();
    const card = currentCard();
    if (!deck || !card) return;
    const index = deck.cards.findIndex((item) => item.id === card.id);
    state.selectedCardId = deck.cards[Math.min(index + 1, deck.cards.length - 1)]?.id ?? card.id;
    state.studyShowsBack = false;
    renderStudy();
  });

  elements.studyStarToggle.addEventListener("click", () => {
    const card = currentCard();
    if (!card) return;
    card.isStarred = !card.isStarred;
    renderStudy();
  });

  elements.deckTitleInput.addEventListener("input", (event) => {
    const deck = currentDeck();
    if (!deck) return;
    deck.title = event.target.value;
    render();
  });

  elements.addCardButton.addEventListener("click", () => {
    const deck = currentDeck();
    if (!deck) return;
    const frontText = elements.newCardFront.value.trim();
    const backText = elements.newCardBack.value.trim();
    if (!frontText && !backText) return;
    const card = {
      id: crypto.randomUUID(),
      frontText,
      backText,
      noteText: "",
      isStarred: false,
      images: [],
    };
    deck.cards.push(card);
    state.selectedCardId = card.id;
    state.studyShowsBack = false;
    elements.newCardFront.value = "";
    elements.newCardBack.value = "";
    render();
  });

  render();
})();

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function escapeAttribute(value) {
  return escapeHtml(value);
}
