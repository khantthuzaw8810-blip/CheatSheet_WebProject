<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CheatSheet — Workspace</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root{
      --bg:#f6f7f9;
      --card:#ffffff;
      --accent:#2b8a3e;
      --accent-2:#1f6f33;
      --muted:#6b7280;
      --shadow: 0 12px 36px rgba(12,18,26,0.06);
      --radius:14px;
      --mono: ui-monospace, SFMono-Regular, Menlo, Monaco, "Roboto Mono", monospace;
    }
    *{box-sizing:border-box}
    body{ margin:0; font-family:Inter, 'Segoe UI', Roboto, Arial, sans-serif; background:var(--bg); color:#071022; padding:32px; -webkit-font-smoothing:antialiased; }
    .wrap{ max-width:1200px; margin:0 auto; border-radius:16px; overflow:hidden; background:linear-gradient(180deg, rgba(255,255,255,0.95), #fff); box-shadow:0 20px 60px rgba(7,16,34,0.06); border:1px solid rgba(15,23,36,0.03); }

    /* Top bar */
    .topbar{ display:flex; justify-content:space-between; align-items:center; padding:18px 28px; border-bottom:1px solid rgba(15,23,36,0.03); }
    .brand{ display:flex; align-items:center; gap:14px; }
    .logo-mark{ width:64px; height:44px; border-radius:10px; display:flex; align-items:center; justify-content:center; background:linear-gradient(90deg,var(--accent),var(--accent-2)); color:#fff; font-weight:800; font-size:18px; box-shadow:0 8px 20px rgba(43,138,62,0.12); }
    .wordmark{ display:flex; flex-direction:column; line-height:1; margin-left:6px; }
    .wordmark .title{ font-weight:900; font-size:18px; letter-spacing:0.6px; color:#071022; }
    .wordmark .sub{ font-size:12px; color:var(--muted); margin-top:2px; }

    /* Auth */
    .auth{ display:flex; flex-direction:column; gap:10px; align-items:flex-end; }
    .auth a{ text-decoration:none; padding:8px 14px; border-radius:999px; font-weight:700; font-size:13px; display:inline-flex; gap:8px; align-items:center; border:1px solid transparent; }
    .auth .login{ background:#fff; border:1px solid rgba(7,16,34,0.06); color:#071022; box-shadow:0 6px 18px rgba(11,18,32,0.04); }
    .auth .register{ background:linear-gradient(90deg,var(--accent),var(--accent-2)); color:#fff; box-shadow:0 10px 30px rgba(43,138,62,0.12); }

    /* Main Grid Layout */
    .main{ display:grid; grid-template-columns:1fr 360px; gap:28px; padding:28px; align-items:start; }

    /* Hero Section */
    .hero{ background:var(--card); border-radius:12px; padding:28px; box-shadow:var(--shadow); border:1px solid rgba(15,23,36,0.03); display:flex; flex-direction:column; gap:20px; }
    .hero-top{ display:flex; justify-content:space-between; align-items:center; gap:12px; }
    .headline{ font-weight:900; font-size:28px; margin:0; color:#071022; letter-spacing:-0.5px; }
    .mini{ color:var(--accent); font-weight:700; font-size:14px; margin-top:2px; }
    
    .search-box { display:flex; background:#f1f3f5; border-radius:10px; padding:6px 12px; align-items:center; gap:10px; margin-top:8px; }
    .search-box input { border:0; background:transparent; width:100%; padding:8px; font-size:14px; outline:none; }
    .hero-actions{ display:flex; gap:12px; }
    .btn-primary{ background:linear-gradient(90deg,var(--accent),var(--accent-2)); color:#fff; padding:10px 16px; border-radius:10px; font-weight:800; text-decoration:none; box-shadow:0 10px 30px rgba(43,138,62,0.12); border:0; cursor:pointer; }
    .btn-ghost{ background:transparent; color:#071022; padding:10px 16px; border-radius:10px; border:1px solid rgba(7,16,34,0.06); font-weight:700; text-decoration:none; }

    /* Spotlight Showcase */
    .showcase{
      display:flex; gap:16px; align-items:center; padding:18px; border-radius:12px; 
      background:linear-gradient(135deg, #111827, #1f2937); color:#fff;
    }
    .showcase .big-logo{
      width:60px; height:60px; border-radius:12px; display:flex; align-items:center; justify-content:center;
      background:rgba(255,255,255,0.08); color:var(--accent); font-weight:900; font-size:24px;
    }
    .showcase .meta { flex:1; }
    .showcase .meta .ftitle{ font-weight:800; font-size:15px; color:#f9fafb; }
    .showcase .meta .fdesc{ color:#9ca3af; font-size:13px; margin-top:2px; }

    /* Sidebar Widgets */
    .sidebar{ display:flex; flex-direction:column; gap:20px; }
    .sidebar-widget { background:#fff; border-radius:12px; padding:20px; border:1px solid rgba(15,23,36,0.04); box-shadow:var(--shadow); }
    .widget-title { font-size:15px; font-weight:800; margin:0 0 14px 0; color:#071022; display:flex; align-items:center; gap:8px; }

    /* Sidebar Widgets Elements */
    .tag-cloud { display:flex; flex-wrap:wrap; gap:8px; }
    .tag-link { text-decoration:none; background:#f8fafc; border:1px solid #e2e8f0; color:#475569; padding:6px 12px; border-radius:8px; font-size:12px; font-weight:600; }
    .tag-link:hover { background:var(--accent); color:#fff; }

    .download-list { display:flex; flex-direction:column; gap:12px; }
    .download-item { display:flex; align-items:center; gap:12px; font-size:13px; font-weight:600; color:#334155; }
    .download-item i { color:var(--accent); background:#eef7ee; padding:8px; border-radius:8px; }

    /* ====== WORKSPACE SECTION ====== */
    .workspace-section { padding:24px 28px; background:#f8fafc; border-top:1px solid rgba(15,23,36,0.05); }
    .section-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; margin-top:12px; }
    .section-header h3 { margin:0; font-size:18px; font-weight:900; color:#071022; }

    /* 3-Column Grid for All Cards */
    .library-grid{ 
      display:grid; 
      grid-template-columns:repeat(3, 1fr); 
      gap:20px; 
      align-items:stretch;
      margin-bottom:28px;
    }
    .sheet-card{ 
      background:#fff; border-radius:12px; padding:20px; 
      border:1px solid rgba(15,23,36,0.06); box-shadow:0 8px 24px rgba(12,18,26,0.02); 
      display:flex; flex-direction:column; gap:12px; height:100%;
    }
    .sheet-title{ font-weight:800; color:#071022; font-size:15px; margin:0; }
    .sheet-tags{ display:flex; gap:6px; flex-wrap:wrap; }
    .tag{ background:#eef7ee; color:var(--accent); padding:4px 10px; border-radius:6px; font-weight:700; font-size:11px; }
    
    .code-preview{ 
      background:#0b1220; color:#d1f7d6; font-family:var(--mono); font-size:13px; 
      padding:14px; border-radius:8px; overflow-x:auto; white-space:pre; 
      line-height:1.4; margin:0; flex-grow:1; width:100%;
    }

    /* 1-Column Full Width for Star Logo Display Box */
    .full-width-grid {
      display: grid;
      grid-template-columns: 1fr;
      gap: 20px;
      margin-bottom: 28px;
    }
    .java-logo-header {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .java-icon-style {
      color: #f89820; /* Real Java Orange/Red Accent */
      font-size: 22px;
    }
    .console-box {
      background: #090d16;
      color: #38bdf8; /* Terminal cyan color for contrast */
      font-family: var(--mono);
      font-size: 14px;
      padding: 24px;
      border-radius: 10px;
      overflow-x: auto;
      white-space: pre;
      line-height: 1.3;
      margin: 0;
      border-left: 4px solid #f89820;
    }

    /* Interactive Developer Tools Row */
    .tools-grid { display:grid; grid-template-columns: 1fr 1.5fr; gap:20px; margin-top:28px; border-top:1px solid #e2e8f0; padding-top:28px; }
    .tool-box { background:#fff; border-radius:12px; padding:20px; border:1px solid #e2e8f0; box-shadow:0 4px 12px rgba(0,0,0,0.01); }
    .tool-box h4 { margin:0 0 12px 0; font-size:15px; font-weight:800; display:flex; align-items:center; gap:8px; }
    
    .notepad-area { width:100%; height:120px; border-radius:8px; border:1px solid #e2e8f0; padding:10px; font-size:13px; resize:none; outline:none; background:#fffdf5; font-family:inherit; }
    
    .compiler-box { background:#1e293b; border-radius:8px; padding:12px; display:flex; flex-direction:column; gap:8px; }
    .compiler-input { background:transparent; border:0; color:#38bdf8; font-family:var(--mono); font-size:13px; outline:none; width:100%; }
    .compiler-btn { align-self:flex-end; background:var(--accent); color:#fff; border:0; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:700; cursor:pointer; }

    @media (max-width:1100px){ .library-grid, .tools-grid { grid-template-columns:1fr; } .main{ grid-template-columns:1fr; } }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="topbar">
      <div class="brand">
        <div class="logo-mark">CS</div>
        <div class="wordmark">
          <div class="title">CHEAT</div>
          <div class="title" style="color:var(--accent); margin-top:-6px;">SHEET</div>
          <div class="sub">Your quick coding reference</div>
        </div>
      </div>
      <div class="auth">
        <a href="login.jsp" class="login"><i class="fa-solid fa-lock"></i> Log In</a>
        <a href="register.jsp" class="register"><i class="fa-solid fa-user-plus"></i> Register</a>
      </div>
    </div>

    <div class="main">
      <section class="hero">
        <div class="hero-top">
          <div>
            <div class="headline">Developer Workspace</div>
            <div class="mini">Curated Cheatsheets & Active Toolkit</div>
          </div>
          <div style="background:#e9f7ee; padding:6px 12px; border-radius:8px; font-weight:700; color:var(--accent); font-size:13px;">v2.0 Active</div>
        </div>

        <div class="search-box">
          <i class="fa-solid fa-magnifying-glass" style="color:var(--muted)"></i>
          <input type="text" placeholder="Filter current workspace...">
        </div>

        <div class="hero-actions">
          <button class="btn-primary">Create New Sheet</button>
          <a class="btn-ghost" href="#tools">Open Developer Tools</a>
        </div>

        <div class="showcase">
          <div class="big-logo"><i class="fa-solid fa-fire"></i></div>
          <div class="meta">
            <div class="ftitle">System Notice: Offline Mode Ready</div>
            <div class="fdesc">Your loaded snippets are securely cached for local offline programming.</div>
          </div>
        </div>
      </section>

      <aside class="sidebar">
        <div class="sidebar-widget">
          <h4 class="widget-title"><i class="fa-solid fa-tags" style="color:var(--accent);"></i> Quick Filters</h4>
          <div class="tag-cloud">
            <a href="#" class="tag-link">Java Core</a>
            <a href="#" class="tag-link">JS Async</a>
            <a href="#" class="tag-link">SQL Join</a>
            <a href="#" class="tag-link">Git Workflow</a>
          </div>
        </div>

        <div class="sidebar-widget">
          <h4 class="widget-title"><i class="fa-solid fa-clock-rotate-left"></i> Recent Exports</h4>
          <div class="download-list">
            <div class="download-item">
              <i class="fa-solid fa-file-code"></i>
              <div>java_streams_api.pdf</div>
            </div>
            <div class="download-item">
              <i class="fa-solid fa-file-code"></i>
              <div>fetch_request_js.txt</div>
            </div>
          </div>
        </div>
      </aside>
    </div>

    <section class="workspace-section" id="library">
      
      <div class="section-header">
        <h3>Primary CheatSheets</h3>
        <div style="color:var(--muted);font-size:13px;">Standard Framework Templates</div>
      </div>

      <div class="library-grid">
        <article class="sheet-card">
          <div class="sheet-title">Java — For-each & Streams</div>
          <div class="sheet-tags"><div class="tag">Java</div><div class="tag">Collections</div></div>
          <pre class="code-preview">List&lt;String&gt; names = List.of("A","B");
names.forEach(System.out::println);

list.stream()
    .filter(s -&gt; s.startsWith("A"))
    .collect(Collectors.toList());</pre>
        </article>

        <article class="sheet-card">
          <div class="sheet-title">Web — Fetch API (JS)</div>
          <div class="sheet-tags"><div class="tag">Web</div><div class="tag">JS</div></div>
          <pre class="code-preview">fetch('/api/data')
  .then(r =&gt; r.json())
  .then(data =&gt; console.log(data));</pre>
        </article>

        <article class="sheet-card">
          <div class="sheet-title">SQL — Select with Join</div>
          <div class="sheet-tags"><div class="tag">Database</div><div class="tag">SQL</div></div>
          <pre class="code-preview">SELECT u.name, o.total
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE o.total &gt; 100;</pre>
        </article>
      </div>

      <div class="section-header">
        <h3>Extended CheatSheets</h3>
        <div style="color:var(--muted);font-size:13px;">Advanced Snippets & Utilities</div>
      </div>

      <div class="library-grid">
        <article class="sheet-card">
          <div class="sheet-title">Java — Optional Class</div>
          <div class="sheet-tags"><div class="tag">Java</div><div class="tag">Features</div></div>
          <pre class="code-preview">Optional&lt;String&gt; opt = Optional.ofNullable(str);
opt.ifPresent(System.out::println);
String value = opt.orElse("Default");</pre>
        </article>

        <article class="sheet-card">
          <div class="sheet-title">JS — Async / Await</div>
          <div class="sheet-tags"><div class="tag">JavaScript</div><div class="tag">Async</div></div>
          <pre class="code-preview">async function loadData() {
  try {
    const res = await fetch('/url');
    const data = await res.json();
    return data;
  } catch (err) {
    console.error(err);
  }
}</pre>
        </article>

        <article class="sheet-card">
          <div class="sheet-title">CSS — Grid Layout</div>
          <div class="sheet-tags"><div class="tag">Web</div><div class="tag">CSS</div></div>
          <pre class="code-preview">.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 16px;
  align-items: stretch;
}</pre>
        </article>
      </div>

      <div class="section-header">
        <h3>Java Console Output</h3>
        <div style="color:var(--muted);font-size:13px;">ASCII Art Java Logo Generated by Print Statements</div>
      </div>

      <div class="full-width-grid">
        <article class="sheet-card">
          <div class="java-logo-header">
            <i class="fa-brands fa-java java-icon-style"></i>
            <div class="sheet-title">Console Window — java_logo_output.log</div>
          </div>
          <div class="sheet-tags">
            <div class="tag" style="background:#fff3e0; color:#e65100;">Active Terminal</div>
            <div class="tag">ASCII Art</div>
          </div>
          <pre class="console-box">
            
             
                                        </pre>
        </article>
      </div>

      <div class="tools-grid" id="tools">
        <div class="tool-box">
          <h4><i class="fa-solid fa-pen-to-square" style="color:#c79b2b"></i> Scratchpad</h4>
          <textarea class="notepad-area" placeholder="Write temporary notes or raw text buffers here..."></textarea>
        </div>

        <div class="tool-box">
          <h4><i class="fa-solid fa-terminal" style="color:var(--accent)"></i> Live JS Terminal</h4>
          <div class="compiler-box">
            <input type="text" class="compiler-input" value="console.log('Hello From WorkSpace!');" id="jsInput">
            <button class="compiler-btn" onclick="runMockCode()">Run Code</button>
          </div>
        </div>
      </div>
    </section>
  </div>

  <script>
    function runMockCode() {
      const input = document.getElementById('jsInput').value;
      alert("Terminal Execution Mockup:\n" + input + "\n\nResult: Executed Successfully!");
    }
  </script>
</body>
</html>