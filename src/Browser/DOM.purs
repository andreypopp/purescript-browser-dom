module Browser.DOM where

import Control.Monad.Eff
import Data.Maybe

-- TODO: separate into DOMRead and DOMWrite
foreign import data DOM :: !
foreign import data Node :: *

type DOMEff result = forall eff. Eff (dom :: DOM | eff) result

foreign import ensure
  "function ensure(v) { \
  \  return v === undefined || v === null ? \
  \    Data_Maybe.Nothing : Data_Maybe.Just(v); \
  \}"
  :: forall a. a

foreign import getDocument
  "function getDocument() { \
  \  return document; \
  \}"
  :: DOMEff Node

foreign import getBody
  "function getBody() { \
  \  return document.body; \
  \}"
  :: DOMEff Node

foreign import createElement
  "function createElement(tagName) { \
  \  return function() { \
  \    return document.createElement(tagName); \
  \  } \
  \}"
  :: forall eff. String -> DOMEff Node

foreign import getElementById
  "function getElementById(id) { \
  \  return function() { return ensure(document.getElementById(id)); }; \
  \}"
  :: forall eff. String -> DOMEff (Maybe Node)

foreign import getElementsByTagName
  "function getElementsByTagName(tagName) { \
  \  return function() { return Array.prototype.slice.call(document.getElementsByTagName(tagName)); }; \
  \}"
  :: forall eff. String -> DOMEff [Node]

foreign import appendChild
  "function appendChild(parent) { \
  \  return function(node) { \
  \    return function() { \
  \      parent.appendChild(node); \
  \      return node; \
  \    } \
  \  } \
  \}"
  :: forall eff. Node -> Node -> DOMEff Node

foreign import parentNode
  "function parentNode(node) { \
  \  return function() { \
  \    return ensure(node.parentNode); \
  \  } \
  \}"
  :: forall eff. Node -> DOMEff (Maybe Node)

foreign import value
  "function value(node) { \
  \  return function() { return ensure(node.value); } \
  \}"
  :: forall eff. Node -> DOMEff (Maybe String)

foreign import onDOMContentLoaded
  "function onDOMContentLoaded(action) { \
  \  if (document.readyState === 'interactive') { \
  \    action(); \
  \  } else { \
  \    document.addEventListener('DOMContentLoaded', action); \
  \  } \
  \  return function() { return {}; }; \
  \}"
  :: forall eff a. Eff (dom :: DOM | eff) a -> Eff (eff) {}

import Debug.Trace

foreign import size
  "function size(arr) { return arr.length; }"
  :: forall a. [a] -> Number

main :: Eff (trace :: Debug.Trace.Trace) {}
main = onDOMContentLoaded do
  countHeaders
  appendHeader
  countHeaders
    where
  countHeaders = do
    nodes <- getElementsByTagName "header"
    print $ size nodes
  appendHeader = do
    body <- getBody
    header <- createElement "header"
    appendChild body header
