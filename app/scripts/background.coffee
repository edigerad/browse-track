'use strict';

chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)

chrome.browserAction.setBadgeText({text: 'HELLO!'})

Stat =
  data: {}
  cur: null

  chrome.storage.sync.get ("stcksf") , (data)->
  console.log data

tabChanged = (url) ->
  if Stat.cur
    lst = Stat.data[Stat.cur]
    lst.push(new Date())
  console.log Stat.data
  [d, other] = url.split '://'
  [domain, oth] = other.split '/'
  url = d + "://" + domain

  Stat.cur = url
  lst = Stat.data[url] or []
  lst.push(new Date())
  chrome.storage.sync.set("stcksf": JSON.stringify(Stat.data))
  Stat.data[url] = lst

calc = (url)->
  [d, other] = url.split '://'
  [domain, oth] = other.split '/'
  url = d + "://" + domain
  lst = Stat.data[url]

  if not lst
    return 0





  [d, other] = url.split '://'
  if d not in ['http', 'https']
    return 0



  n = Math.floor (lst.length / 2)
  res = 0
  for i in [0..n]
    if lst[2 * i + 1] and lst[2 * i]
      res += lst[2 * i + 1].getTime() - lst[2 * i].getTime()
  res += (new Date()).getTime() - lst[lst.length - 1].getTime()
  return res

updateBadge = (url)->
  res = calc url

  hh = res // (60*60*60000)
  mm = res // (60000)
  ss = parseInt(((res % 60000) / 1000)%60)
  HH = 
  if hh <= 9
    '0'+hh
  else
    hh

  MM = 
  if mm <= 9
    '0'+mm
  else
    mm

  SS = 
  if ss <= 9
    '0'+ss
  else
    ss
  chrome.browserAction.setBadgeText({text: "#{HH}:#{MM}:#{SS}"})

chrome.tabs.onActivated.addListener (activeInfo)->
  Stat.curTabId = activeInfo.tabId
  chrome.tabs.get activeInfo.tabId, (tab) ->
    tabChanged(tab.url) if tab.url
    updateBadge tab.url

chrome.alarms.onAlarm.addListener (alarm)->
  Stat.curTabId
  if alarm.name == "update"
    if not Stat.curTabId
      return
    chrome.tabs.get Stat.curTabId, (tab)->
      if tab.url
        updateBadge tab.url

chrome.alarms.create("update", {periodInMinutes: 0.001})

