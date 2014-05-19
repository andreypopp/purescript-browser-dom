module Browser.DOM.Events where

import Browser.DOM

type Event = {
  eventType :: String,
  target :: Node,
  currentTarget :: Node,
  stopPropagation :: DOMEff {},
  preventDefault :: DOMEff {}
  }

type MouseEvent = {
  eventType :: String,
  target :: Node,
  currentTarget :: Node,
  stopPropagation :: DOMEff {},
  preventDefault :: DOMEff {},

  pageX :: Number,
  pageY :: Number,

  screenX :: Number,
  screenY :: Number,

  clientX :: Number,
  clientY :: Number,

  ctrlKey :: Boolean,
  shiftKey :: Boolean,
  altKey :: Boolean,
  metaKey :: Boolean,
  button :: Number
  }
