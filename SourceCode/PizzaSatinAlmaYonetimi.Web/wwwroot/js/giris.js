document.querySelector('.sifre-goster')?.addEventListener('click', event => {
    const button = event.currentTarget;
    const input = document.getElementById('Sifre');
    const showing = input.type === 'text';
    input.type = showing ? 'password' : 'text';
    button.setAttribute('aria-pressed', String(!showing));
    button.setAttribute('aria-label', showing ? 'Şifreyi göster' : 'Şifreyi gizle');
});
