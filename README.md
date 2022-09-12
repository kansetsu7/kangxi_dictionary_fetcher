# zh-TW _dictionary fetcher

A web scraper based on [Nogokiri](https://github.com/sparklemotion/nokogiri).
Fetch characters and its strokes from two online dictionaries, then output as text file.

- [筆順字典](https://www.twpen.com) : modern dictionary, strokes of character is same as what it actually count.
- [康熙字典網上版](https://kangxizidian.com) : Kang Xi dictionary, strokes of some characters are different from modern dictionary. 

---

使用 [Nogokiri](https://github.com/sparklemotion/nokogiri) 抓取線上字典的筆畫及字，並輸出成文字檔。
字典來源有二：

- [筆順字典](https://www.twpen.com) : 現代版字典，筆劃數與字實際上算出來的相同。
- [康熙字典網上版](https://kangxizidian.com) : 康熙字典，有些字的筆畫數計算方式不同。部分字僅有字碼但無法顯示，會被排除在外。
